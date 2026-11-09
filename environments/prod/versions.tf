terraform {
  required_version = ">= 1.7.0"

  cloud {
    organization = "ace-intelligence"

    workspaces {
      name = "ace-intelligence-prod"
    }
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.43"
    }
  }
}
