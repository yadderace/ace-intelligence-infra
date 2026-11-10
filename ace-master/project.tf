resource "digitalocean_project" "this" {
  name        = "ace-master"
  description = "Production environment for ace-intelligence"
  purpose     = "Web Application"
  environment = "Production"
}
