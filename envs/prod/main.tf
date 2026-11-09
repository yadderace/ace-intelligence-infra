locals {
  env  = "prod"
  tags = ["env:${local.env}", "app:ipcservices", "managed-by:terraform"]
}

data "digitalocean_ssh_key" "main" {
  name = var.ssh_key_name
}

resource "digitalocean_vpc" "main" {
  name     = "ipc-${local.env}-vpc"
  region   = var.region
  ip_range = "10.20.0.0/24"
}

# Droplets carrying this tag are the only ones the database firewall admits.
resource "digitalocean_tag" "web" {
  name = "ipc-${local.env}-web"
}

# Secret used by the backend to sign JWTs. Lives in state; keep state private.
resource "random_password" "jwt_secret" {
  length  = 48
  special = false
}

module "database" {
  source = "../../modules/database"

  name         = "ipc-${local.env}-pg"
  region       = var.region
  size         = var.db_size
  vpc_uuid     = digitalocean_vpc.main.id
  db_name      = var.db_name
  allowed_tags = [digitalocean_tag.web.name]
  tags         = local.tags
}

module "droplet" {
  source = "../../modules/droplet"

  name        = "ipc-${local.env}-web-01"
  region      = var.region
  size        = var.droplet_size
  vpc_uuid    = digitalocean_vpc.main.id
  ssh_key_ids = [data.digitalocean_ssh_key.main.id]
  admin_cidrs = var.admin_cidrs
  tags        = concat(local.tags, [digitalocean_tag.web.name])

  # Writes /opt/ipcservices/.env on first boot. DB host is the private (VPC) one.
  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    db_host    = module.database.private_host
    db_port    = module.database.port
    db_name    = module.database.db_name
    db_user    = module.database.username
    db_pass    = module.database.password
    jwt_secret = random_password.jwt_secret.result
  })
}

# Stable public IP: survives droplet rebuilds, so DNS never has to change.
resource "digitalocean_reserved_ip" "web" {
  region = var.region
}

resource "digitalocean_reserved_ip_assignment" "web" {
  ip_address = digitalocean_reserved_ip.web.ip_address
  droplet_id = module.droplet.id
}

resource "digitalocean_project" "ipc" {
  name        = "ipc-${local.env}"
  description = "ipcservices school management system (${local.env})"
  purpose     = "Web Application"
  environment = "Production"

  resources = [
    module.droplet.urn,
    module.database.urn,
    digitalocean_reserved_ip.web.urn,
  ]
}
