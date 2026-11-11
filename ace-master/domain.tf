# Registers popolhub.com as a DNS zone in this DO account, now that its
# nameservers are delegated here. Required before App Platform's "zone"
# field (in app_platform/popolhub_frontend.tf) can manage records for it.
resource "digitalocean_domain" "popolhub" {
  name = "popolhub.com"
}

# digitalocean_domain has no project_id field, so it lands in the account's
# default project unless explicitly assigned here.
resource "digitalocean_project_resources" "popolhub_domain" {
  project = digitalocean_project.this.id
  resources = [
    digitalocean_domain.popolhub.urn
  ]
}
