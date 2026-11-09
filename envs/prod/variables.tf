variable "region" {
  description = "DigitalOcean region slug for all resources."
  type        = string
  default     = "nyc3"
}

variable "ssh_key_name" {
  description = "Name of an SSH key already uploaded to your DigitalOcean account."
  type        = string
}

variable "admin_cidrs" {
  description = "CIDRs allowed to SSH to the droplet, e.g. [\"203.0.113.7/32\"]."
  type        = list(string)

  validation {
    condition     = !contains(var.admin_cidrs, "0.0.0.0/0")
    error_message = "Do not open SSH to the whole internet; list specific CIDRs."
  }
}

variable "droplet_size" {
  description = "Droplet size slug."
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "db_size" {
  description = "Managed Postgres node size slug."
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "db_name" {
  description = "Application database name."
  type        = string
  default     = "school_management"
}
