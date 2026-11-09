output "urn" {
  description = "Cluster URN (for digitalocean_project)."
  value       = digitalocean_database_cluster.this.urn
}

output "private_host" {
  description = "VPC-private hostname. Use this from the droplet."
  value       = digitalocean_database_cluster.this.private_host
}

output "port" {
  description = "Cluster port (25060, not 5432)."
  value       = digitalocean_database_cluster.this.port
}

output "db_name" {
  description = "Application database name."
  value       = digitalocean_database_db.app.name
}

output "username" {
  description = "Admin username (doadmin)."
  value       = digitalocean_database_cluster.this.user
}

output "password" {
  description = "Admin password."
  value       = digitalocean_database_cluster.this.password
  sensitive   = true
}
