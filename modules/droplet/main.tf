resource "digitalocean_droplet" "this" {
  name       = var.name
  region     = var.region
  size       = var.size
  image      = var.image
  vpc_uuid   = var.vpc_uuid
  ssh_keys   = var.ssh_key_ids
  user_data  = var.user_data
  backups    = var.backups
  monitoring = true
  ipv6       = false
  tags       = var.tags

  lifecycle {
    # user_data only runs on first boot; editing it must not rebuild the server.
    ignore_changes = [user_data, image]
  }
}

# Firewall targets the tags, so replacing the droplet keeps the rules attached.
resource "digitalocean_firewall" "this" {
  name = "${var.name}-fw"
  tags = var.tags

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.admin_cidrs
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow all outbound (package installs, image pulls, managed DB, DNS).
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
