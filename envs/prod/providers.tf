terraform {
  required_version = ">= 1.9.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Remote state in a DigitalOcean Space (S3-compatible).
  # Create the Space by hand first (see README), then export
  # AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY with your Spaces keys.
  # Backend blocks cannot use variables, so edit bucket/endpoint here.
  backend "s3" {
    bucket = "ipc-tfstate"
    key    = "prod/terraform.tfstate"
    region = "us-east-1" # dummy value required by the S3 backend

    endpoints = {
      s3 = "https://nyc3.digitaloceanspaces.com"
    }

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
}

# Token comes from the DIGITALOCEAN_TOKEN environment variable.
provider "digitalocean" {}
