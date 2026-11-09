resource "digitalocean_database_cluster" "this" {
  name                 = var.name
  engine               = "pg"
  version              = var.pg_version
  size                 = var.size
  region               = var.region
  node_count           = var.node_count
  private_network_uuid = var.vpc_uuid
  tags                 = var.tags

  lifecycle {
    # Guard against an accidental `terraform destroy` wiping production data.
    prevent_destroy = true
  }
}

resource "digitalocean_database_db" "app" {
  cluster_id = digitalocean_database_cluster.this.id
  name       = var.db_name
}

# Trusted sources: only the listed droplets can connect. Without this
# resource a managed DB accepts connections from anywhere.
resource "digitalocean_database_firewall" "this" {
  cluster_id = digitalocean_database_cluster.this.id

  # Tag-based (not droplet-ID-based) so the droplet can depend on this cluster
  # for its user_data without creating a dependency cycle.
  dynamic "rule" {
    for_each = toset(var.allowed_tags)
    content {
      type  = "tag"
      value = rule.value
    }
  }
}
