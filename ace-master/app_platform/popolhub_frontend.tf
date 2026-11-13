# Frontend as its own App Platform app, deployed independently of the backend.
resource "digitalocean_app" "popolhub_frontend" {
  project_id = var.project_id

  spec {
    name   = "popolhub-frontend"
    region = "nyc"

    static_site {
      name             = "frontend"
      source_dir       = "frontend"
      environment_slug = "node-js"
      build_command    = "npm run build"
      output_dir       = "dist"
      # Needed for react-router-dom's client-side routes.
      catchall_document = "index.html"

      github {
        repo           = "yadderace/ace-intelligence-services"
        branch         = "main"
        deploy_on_push = true
      }

      env {
        key   = "VITE_API_URL"
        value = "https://api.${var.root_domain}"
        scope = "BUILD_TIME"
      }
    }

    # Omitted until root_domain is set; app uses the default
    # *.ondigitalocean.app URL + HTTPS until then.
    dynamic "domain" {
      for_each = var.root_domain != "" ? [1] : []
      content {
        name = "www.${var.root_domain}"
        type = "PRIMARY"
        zone = var.root_domain
      }
    }

    dynamic "domain" {
      for_each = var.root_domain != "" ? [1] : []
      content {
        name = var.root_domain
        type = "ALIAS"
        zone = var.root_domain
      }
    }

    dynamic "ingress" {
      for_each = var.root_domain != "" ? [1] : []
      content {
        rule {
          match {
            authority {
              exact = var.root_domain
            }
          }
          redirect {
            authority     = "www.${var.root_domain}"
            scheme        = "https"
            port          = 443
            redirect_code = 301
          }
        }

        # Catchall routing requests to the static site itself.
        rule {
          match {
            path {
              prefix = "/"
            }
          }
          component {
            name = "frontend"
          }
        }
      }
    }
  }
}
