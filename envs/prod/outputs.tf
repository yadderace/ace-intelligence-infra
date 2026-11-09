output "reserved_ip" {
  description = "Public IP to point DNS at and to SSH/browse to."
  value       = digitalocean_reserved_ip.web.ip_address
}

output "droplet_ipv4" {
  description = "Droplet's own public IP (the reserved IP is the stable one)."
  value       = module.droplet.ipv4_address
}

output "db_private_host" {
  description = "Managed Postgres private hostname (reachable only inside the VPC)."
  value       = module.database.private_host
}

output "db_port" {
  description = "Managed Postgres port."
  value       = module.database.port
}
