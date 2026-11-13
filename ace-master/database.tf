resource "digitalocean_database_cluster" "postgres" {
  name       = "popolhub-db"
  engine     = "pg"
  version    = "18"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
  project_id = digitalocean_project.this.id
}

resource "digitalocean_database_db" "app" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "popolhub"
}

resource "digitalocean_database_firewall" "popolhub_db_firewall" {
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "app"
    value = module.app_platform.backend_app_id
  }
}

data "digitalocean_database_ca" "popolhub_db_ca" {
  cluster_id = digitalocean_database_cluster.postgres.id
}
