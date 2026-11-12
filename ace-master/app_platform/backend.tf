# Backend as its own App Platform app, deployed independently of the frontend.
resource "digitalocean_app" "popolhub_backend" {
  project_id = var.project_id

  spec {
    name   = "popolhub-backend"
    region = "nyc"

    service {
      name               = "backend"
      source_dir         = "backend"
      dockerfile_path    = "backend/Dockerfile"
      http_port          = 5000
      instance_size_slug = "basic-xxs"
      instance_count     = 1

      github {
        repo           = "yadderace/ace-intelligence-services"
        branch         = "main"
        deploy_on_push = true
      }

      health_check {
        http_path = "/api/health"
      }

      env {
        key   = "NODE_ENV"
        value = "production"
      }
      env {
        key   = "TYPEORM_LOGGING"
        value = "false"
      }
      env {
        key   = "DB_HOST"
        value = var.db_host
      }
      env {
        key   = "DB_PORT"
        value = tostring(var.db_port)
      }
      env {
        key   = "DB_NAME"
        value = var.db_name
      }
      env {
        key   = "DB_USERNAME"
        value = var.db_username
        type  = "SECRET"
      }
      env {
        key   = "DB_PASSWORD"
        value = var.db_password
        type  = "SECRET"
      }
      env {
        key   = "DB_SSL"
        value = "true"
      }
      env {
        key   = "DB_SSL_CA"
        value = var.db_ssl_ca
        type  = "SECRET"
      }
      env {
        key   = "JWT_SECRET"
        value = var.jwt_secret
        type  = "SECRET"
      }
      env {
        key   = "FRONTEND_URL"
        value = var.frontend_url
      }
    }

    dynamic "domain" {
      for_each = var.root_domain != "" ? [1] : []
      content {
        name = "api.${var.root_domain}"
        type = "PRIMARY"
        zone = var.root_domain
      }
    }
  }
}
