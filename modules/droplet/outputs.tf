output "id" {
  description = "Droplet ID."
  value       = digitalocean_droplet.this.id
}

output "urn" {
  description = "Droplet URN (for digitalocean_project)."
  value       = digitalocean_droplet.this.urn
}

output "ipv4_address" {
  description = "Public IPv4 address."
  value       = digitalocean_droplet.this.ipv4_address
}

output "ipv4_address_private" {
  description = "VPC-private IPv4 address."
  value       = digitalocean_droplet.this.ipv4_address_private
}
