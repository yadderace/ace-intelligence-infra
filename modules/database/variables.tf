variable "name" {
  description = "Cluster name."
  type        = string
}

variable "region" {
  description = "DigitalOcean region slug. Must match the VPC's region."
  type        = string
}

variable "pg_version" {
  description = "PostgreSQL major version."
  type        = string
  default     = "16"
}

variable "size" {
  description = "Database node size slug."
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "node_count" {
  description = "Number of nodes (1 = no standby, 2-3 = HA)."
  type        = number
  default     = 1
}

variable "vpc_uuid" {
  description = "VPC the cluster is attached to (enables the private host)."
  type        = string
}

variable "db_name" {
  description = "Name of the application database to create."
  type        = string
}

variable "allowed_tags" {
  description = "Droplet tags allowed to connect. Everything else is blocked. Tags must already exist."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to the cluster."
  type        = list(string)
  default     = []
}
