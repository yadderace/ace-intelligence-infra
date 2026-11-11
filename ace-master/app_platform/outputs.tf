output "frontend_app_url" {
  description = "Default App Platform URL for the frontend (until the custom domain is live)"
  value       = digitalocean_app.popolhub_frontend.default_ingress
}
