variable "project_id" {
  description = "ID of the DigitalOcean Project these apps are attached to"
  type        = string
}

variable "root_domain" {
  description = "Root domain already registered as a DO-managed DNS zone (e.g. \"popolhub.com\"). www.<root_domain> becomes the app's PRIMARY domain; the bare root domain redirects to it. Leave unset to use App Platform's default *.ondigitalocean.app URL instead."
  type        = string
  default     = ""
}
