module "app_platform" {
  source      = "./app_platform"
  project_id  = digitalocean_project.this.id
  root_domain = digitalocean_domain.popolhub.name

  db_host     = digitalocean_database_cluster.postgres.host
  db_port     = digitalocean_database_cluster.postgres.port
  db_name     = digitalocean_database_db.app.name
  db_username = digitalocean_database_cluster.postgres.user
  db_password = digitalocean_database_cluster.postgres.password
  db_ssl_ca   = data.digitalocean_database_ca.popolhub_db_ca.certificate

  jwt_secret   = var.jwt_secret
  frontend_url = "https://www.${digitalocean_domain.popolhub.name}"
}

output "frontend_app_url" {
  description = "Default App Platform URL for the frontend (until popolhub.com's DNS is live)"
  value       = module.app_platform.frontend_app_url
}

output "backend_app_url" {
  description = "Default App Platform URL for the backend (until api.popolhub.com's DNS is live)"
  value       = module.app_platform.backend_app_url
}
