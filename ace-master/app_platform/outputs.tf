output "frontend_app_url" {
  description = "Default App Platform URL for the frontend (until the custom domain is live)"
  value       = digitalocean_app.popolhub_frontend.default_ingress
}

output "backend_app_url" {
  description = "Default App Platform URL for the backend (until the custom domain is live)"
  value       = digitalocean_app.popolhub_backend.default_ingress
}

output "backend_app_id" {
  value = digitalocean_app.popolhub_backend.id
}
