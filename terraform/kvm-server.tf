#variable "count" {}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "srv-src" {
  count = var.server_clones
  name = "src-${var.server_name}${count.index}.qcow2"
  pool = "default"
  source = "http://localhost:8080/images/${var.images[var.server_image]}"
  format = "qcow2"
}

resource "libvirt_volume" "srv-vol" {
  count          = var.server_clones
  name           = "${var.server_name}${count.index}"
  base_volume_id = libvirt_volume.srv-src[count.index].id
  pool           = "default"
  size           = 1073741824 * var.server_disk
}

data "template_file" "user_data" {
  count = var.server_clones
  template = file("${path.module}/cloud-init/${var.cloud_init_user_file}")
  vars = {
    server_name = "${var.server_name}${count.index}"
    username = var.user["username"]
    ssh-key = var.user["ssh-key"]
  }
}

data "template_file" "network_config" {
  count = var.server_clones
  template = file("${path.module}/cloud-init/${var.cloud_init_network_file}")
  vars = {
    mac_address = join(":", ["02", join(":", regexall("[a-z|0-9]{2}",substr(md5("${var.server_name}${count.index}"),0,10)))])
    ip_address = cidrhost(var.network_cidr, (var.network_static_ip_start + count.index) )
    cidr_mask = split("/", var.network_cidr)[1]
    network_gw = coalesce( var.network_gw, cidrhost(var.network_cidr, 1))
    network_ns = coalesce( var.network_ns, cidrhost(var.network_cidr, 1))
  }
}

# Use CloudInit to add the instance
resource "libvirt_cloudinit_disk" "init" {
  count = var.server_clones
  name = "init-${var.server_name}${count.index}.iso"
  user_data = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
}

resource "libvirt_network" "network" {
  name      = var.network_name
  domain    = "${var.network_name}.local"
  mode      = "nat"
  addresses = [var.network_cidr]
  dhcp {
    enabled = var.network_dhcp_enabled
  }
  dns {
    enabled = true
  }
}

# Define KVM domain to create
resource "libvirt_domain" "domain" {
  count  = var.server_clones
  name   = "${var.server_name}${count.index}"
  memory = var.server_memory
  vcpu   = var.server_cpu

  network_interface {
    network_name = var.network_name
    mac = join(":", ["02", join(":", regexall("[a-z|0-9]{2}",substr(md5("${var.server_name}${count.index}"),0,10)))])
  }

  disk {
    volume_id = libvirt_volume.srv-vol[count.index].id
  }
  
  cloudinit = libvirt_cloudinit_disk.init[count.index].id
  
  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
  
  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
