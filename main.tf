data "digitalocean_ssh_key" "testkey" {
  name = "testkey"
}


resource "digitalocean_droplet" "minio" {
    count = 1
    image = "ubuntu-20-04-x64"
    name = "minio-${count.index}"
    region = "fra1"
    size = "s-1vcpu-1gb"
    ssh_keys = [
      data.digitalocean_ssh_key.testkey.id
    ]
    tags = [
      "claster-${count.index}"
    ]
}

resource "digitalocean_volume" "minio-volums" {
  count                   = length(digitalocean_droplet.minio)*4
  region                  = digitalocean_droplet.minio[0].region
  name                    = "baz-${digitalocean_droplet.minio[0].name}-${count.index}"
  size                    = 30
  initial_filesystem_type = "xfs"
  description             = "minio volume"
  depends_on = [
    digitalocean_droplet.minio
  ]
}

resource "digitalocean_volume_attachment" "minio-attach" { 
  count = length(digitalocean_volume.minio-volums)
  droplet_id = digitalocean_droplet.minio[0].id
  volume_id  = digitalocean_volume.minio-volums[count.index].id
}

