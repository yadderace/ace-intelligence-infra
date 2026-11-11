# Registers popolhub.com as a DNS zone in this DO account, now that its
# nameservers are delegated here. Required before App Platform's "zone"
# field (in app_platform/popolhub_frontend.tf) can manage records for it.
resource "digitalocean_domain" "popolhub" {
  name = "popolhub.com"
}
