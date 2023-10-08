resource "digitalocean_droplet" "websites-1" {
    image = "ubuntu-23-04-x64"
    name = "wiki-1"
    region = "syd1"
    size = "s-1vcpu-512mb-10gb"
    backups = true
    ssh_keys = [
      data.digitalocean_ssh_key.root.fingerprint
    ]
}

resource "digitalocean_reserved_ip" "websites" {
  droplet_id = digitalocean_droplet.websites-1.id
  region     = digitalocean_droplet.websites-1.region
}

resource "digitalocean_record" "websites" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "@"
  value  = digitalocean_reserved_ip.websites.ip_address
}

resource "digitalocean_project_resources" "websites-resources" {
  project = digitalocean_project.default.id
  resources = [
    digitalocean_droplet.websites-1.urn
  ]
}

