variable "project_id" {
  description = "ID of the DigitalOcean Project these apps are attached to"
  type        = string
}

variable "frontend_domain" {
  description = "Custom domain for the frontend app (e.g. \"popolhub.com\"). Leave unset to use App Platform's default *.ondigitalocean.app URL instead."
  type        = string
  default     = ""
}
