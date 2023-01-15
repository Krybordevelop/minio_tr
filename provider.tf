terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  cloud {
    organization = "example-org-9d7865"

    workspaces {
      name = "test1"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}
