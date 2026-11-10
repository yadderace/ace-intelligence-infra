output "database_host" {
  description = "Hostname of the managed Postgres cluster"
  value       = digitalocean_database_cluster.postgres.host
}

output "database_port" {
  description = "Port the managed Postgres cluster listens on"
  value       = digitalocean_database_cluster.postgres.port
}

output "database_name" {
  description = "Name of the application's database within the cluster"
  value       = digitalocean_database_db.app.name
}

output "database_user" {
  description = "Username for the cluster's default user"
  value       = digitalocean_database_cluster.postgres.user
  sensitive   = true
}

output "database_password" {
  description = "Password for the cluster's default user"
  value       = digitalocean_database_cluster.postgres.password
  sensitive   = true
}

output "database_uri" {
  description = "Full connection URI for the managed Postgres cluster"
  value       = digitalocean_database_cluster.postgres.uri
  sensitive   = true
}
