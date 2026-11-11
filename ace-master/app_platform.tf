module "app_platform" {
  source      = "./app_platform"
  project_id  = digitalocean_project.this.id
  root_domain = digitalocean_domain.popolhub.name
}

output "frontend_app_url" {
  description = "Default App Platform URL for the frontend (until popolhub.com's DNS is live)"
  value       = module.app_platform.frontend_app_url
}
