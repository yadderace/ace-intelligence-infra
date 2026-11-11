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
    }

    # Omitted until frontend_domain is set; app uses the default
    # *.ondigitalocean.app URL + HTTPS until then.
    dynamic "domain" {
      for_each = var.frontend_domain != "" ? [var.frontend_domain] : []
      content {
        name = domain.value
        type = "PRIMARY"
        # Zone must already exist as a DO-managed domain (see domain.tf in
        # the root module) - lets App Platform create/manage its records.
        zone = domain.value
      }
    }
  }
}
