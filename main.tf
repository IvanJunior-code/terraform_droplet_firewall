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


###################### Firewall ######################
resource "digitalocean_firewall" "firewall" {
  name = "firewall-droplet"

  droplet_ids = [digitalocean_droplet.terraform-droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "53" # para pacotes do Linux
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53" # para pacotes do Linux
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}
###################### ######## ######################


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