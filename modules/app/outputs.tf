output "database_host" {
  description = "Hostname of the managed Postgres cluster"
  value       = digitalocean_database_cluster.postgres.host
}

output "database_connection_uri" {
  description = "Full connection URI for the managed Postgres cluster"
  value       = digitalocean_database_cluster.postgres.uri
  sensitive   = true
}
