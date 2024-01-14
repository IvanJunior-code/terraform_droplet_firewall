terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.token
}

###################### Droplet ######################
resource "digitalocean_droplet" "terraform-droplet" {
  image    = var.image
  name     = var.name
  region   = var.region
  size     = var.size
  ssh_keys = [data.digitalocean_ssh_key.ssh-key.id]
}
###################### ####### ######################

##################### Variables #####################
variable "token" {
}

variable "image" {
  default = "ubuntu-23-10-x64" # doctl compute image list --public --format "ID,Name,Slug" | grep ubuntu-
}

variable "name" {
  default = "terraform-droplet"
}

variable "region" {
  default = "nyc1"
}

variable "size" {
  default = "s-1vcpu-2gb" # doctl compute size list
}

data "digitalocean_ssh_key" "ssh-key" {
  name = "droplet_home"
}
##################### ######### #####################

###################### Outputs ######################
output "ssh-key" {
  value = digitalocean_droplet.terraform-droplet.ipv4_address # ip do droplet
}
###################### ####### ######################