variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret used by the backend to sign JWTs (openssl rand -hex 32)"
  type        = string
  sensitive   = true
}
