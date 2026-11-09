output "database_host" {
  description = "Hostname of the managed Postgres cluster"
  value       = module.app.database_host
}

output "database_connection_uri" {
  description = "Full connection URI for the managed Postgres cluster"
  value       = module.app.database_connection_uri
  sensitive   = true
}
