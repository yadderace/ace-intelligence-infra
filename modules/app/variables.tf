variable "region" {
  description = "DigitalOcean region slug (e.g. nyc1, sfo3)"
  type        = string
}

variable "app_name" {
  description = "Base name used to derive resource names (e.g. the database cluster)"
  type        = string
}

variable "db_size" {
  description = "DigitalOcean managed database droplet size slug"
  type        = string
}

variable "db_engine_version" {
  description = "Postgres engine version for the managed database"
  type        = string
}
