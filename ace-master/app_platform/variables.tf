variable "project_id" {
  description = "ID of the DigitalOcean Project these apps are attached to"
  type        = string
}

variable "root_domain" {
  description = "Root domain already registered as a DO-managed DNS zone (e.g. \"popolhub.com\"). www.<root_domain> becomes the frontend's PRIMARY domain, api.<root_domain> the backend's. Leave unset to use App Platform's default *.ondigitalocean.app URLs instead."
  type        = string
  default     = ""
}

variable "db_host" {
  description = "Managed Postgres cluster hostname"
  type        = string
}

variable "db_port" {
  description = "Managed Postgres cluster port"
  type        = number
}

variable "db_name" {
  description = "Database name within the cluster"
  type        = string
}

variable "db_username" {
  description = "Managed Postgres cluster username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Managed Postgres cluster password"
  type        = string
  sensitive   = true
}

variable "db_ssl_ca" {
  description = "Managed Postgres cluster's CA certificate (PEM), to verify the TLS connection"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret used by the backend to sign JWTs"
  type        = string
  sensitive   = true
}

variable "frontend_url" {
  description = "The frontend's public URL - the backend's CORS allow-list and invite-email links"
  type        = string
}
