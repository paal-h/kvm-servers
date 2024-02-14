variable "network_cidr" {
    type = string
    default = "10.10.10.0/24"
    description = "Netwoek cidr, default 10.10.10.0/24"
}

variable "network_static_ip_start" {
    type = number
    default = 10
    description = "Start address for servers with static ip address, default x.x.x.10"    
}

variable "network_gw" {
    type = string
    default = null
    description = "Network gateway address, default x.x.x.1"
}

variable "network_ns" {
    type = string
    default = null
    description = "Network nameserver address, default x.x.x.1"
}

variable "network_name" {
    type = string
    default = "mynet"
    description = "Network name, default mynet"
}

variable "network_dhcp_enabled" {
    type = bool
    default = true
    description = "Enable network dhcp service, default true"
}

variable "server_name" {
    type = string
    default = "srv"
    description = "Server name, default srv"
}

variable "server_clones" {
    type = number
    default = 1
    description = "Number of servers to create, default 1"
}

variable "server_memory" {
    type = number
    default = 1024
    description = "Server memory, default 1024"
}

variable "server_cpu" {
    type = number
    default = 1
    description = "Number og cpu's, default 1"
}

variable "server_disk" {
    type = number
    default = 5
    description = "Disksize in gigabytes, default 5"
}

variable "server_image" {
    type = string
    default = "ubuntu-focal"
    description = "Server image key, default ubuntu-focal"
}

variable "user" {
    type = map(string)
    default = {
        "username" = null
        "ssh-key" = null
    }
}

variable "cloud_init_user_file" {
    type = string
    default = "cloud-init.yml"
    description = "Cloud init file to use, default cloud-init.yml"
}

variable "cloud_init_network_file" {
    type = string
    default = "network-config.yml"
    description = "Cloud init network config file to use, default network-config.yml"
}

variable "images" {
    type = map(string)
    default = {
        "ubuntu-focal" = "focal-server-cloudimg-amd64-disk-kvm.img"
        "ubuntu-jammy" = "jammy-server-cloudimg-amd64-disk-kvm.img"
    }
    description = "Map of server images"
}
