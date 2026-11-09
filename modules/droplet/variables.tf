variable "name" {
  description = "Droplet name (also used as a prefix for the firewall)."
  type        = string
}

variable "region" {
  description = "DigitalOcean region slug, e.g. nyc3."
  type        = string
}

variable "size" {
  description = "Droplet size slug, e.g. s-1vcpu-2gb."
  type        = string
}

variable "image" {
  description = "Droplet image slug."
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "vpc_uuid" {
  description = "ID of the VPC the droplet joins."
  type        = string
}

variable "ssh_key_ids" {
  description = "IDs or fingerprints of the SSH keys injected into the droplet."
  type        = list(string)
}

variable "admin_cidrs" {
  description = "CIDRs allowed to reach SSH (port 22). Never use 0.0.0.0/0."
  type        = list(string)
}

variable "user_data" {
  description = "cloud-init user data run on first boot."
  type        = string
  default     = null
}

variable "backups" {
  description = "Enable automated weekly droplet backups (+20% cost)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the droplet; the firewall targets them."
  type        = list(string)
  default     = []
}
