terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {

}

resource "digitalocean_ssh_key" "minha_chave" {
  name       = "STARLORD"
  public_key = file("/home/jrangel/.ssh/id_ed25519.pub")
}

resource "digitalocean_droplet" "web" {
  image    = "ubuntu-22-04-x64"
  name     = "GENESIS"
  region   = "nyc1"
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [digitalocean_ssh_key.minha_chave.fingerprint]
}

output "ip" {
  value = digitalocean_droplet.web.ipv4_address
}