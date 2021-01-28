# Install
```
./install.sh
```

# Download images and start image server
```
./start-image-server.sh
```

# Download new and update existing images
```
cd ~/kvm-servers/ansible
ansible-playbook image-server.yml -e update_images=true
```

# Example

Create ubuntu focal server
```
cd ~/kvm-servers
ssh-keygen -f ubuntu-focal -N ""
mkdir -p terraform/projects/ubuntu-focal
cat <<EOF> terraform/projects/ubuntu-focal/server.tfvars
server_image="ubuntu-focal"
server_clones=1
server_cpu=1
server_memory=1024
server_disk=5
server_name="ubuntu-focal-"
network_name="ubuntu-focal"
network_dhcp_enabled=false
network_cidr="10.2.3.0/24"
network_static_ip_start="4"
user= {
  "username"="$(echo $USER)"
  "ssh-key"="$(< ubuntu-focal.pub)"
}
EOF
cd terraform
terraform workspace new ubuntu-focal
terraform apply -var-file=projects/ubuntu-focal/server.tfvars
```

Login
```
cd ~/kvm-servers
ssh 10.2.3.4 -i ./ubuntu-focal
```

Delete server
```
cd ~/kvm-servers/terraform
terraform workspace select ubuntu-focal
terraform destroy
```
