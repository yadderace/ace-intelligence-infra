resource "digitalocean_database_cluster" "postgres" {
  name       = "${var.app_name}-db"
  engine     = "pg"
  version    = var.db_engine_version
  size       = var.db_size
  region     = var.region
  node_count = 1
}

resource "digitalocean_database_db" "app" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = replace(var.app_name, "-", "_")
}
