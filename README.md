# Install
```
./install.sh
```
If docker fails to start:
```
sudo systemctl unmask docker
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

Create ubuntu jammy server
```
cd ~/kvm-servers
ssh-keygen -f ubuntu-jammy -N ""
mkdir -p terraform/projects/ubuntu-jammy
cat <<EOF> terraform/projects/ubuntu-jammy/server.tfvars
server_image="ubuntu-jammy"
server_clones=1
server_cpu=1
server_memory=1024
server_disk=5
server_name="ubuntu-jammy-"
network_name="ubuntu-jammy"
network_dhcp_enabled=false
network_cidr="10.2.3.0/24"
network_static_ip_start="4"
user= {
  "username"="$(echo $USER)"
  "ssh-key"="$(< ubuntu-jammy.pub)"
}
EOF
cd terraform
terraform init
terraform workspace new ubuntu-jammy
terraform apply -var-file=projects/ubuntu-jammy/server.tfvars
```

Login
```
cd ~/kvm-servers
ssh 10.2.3.4 -i ./ubuntu-jammy
```

Delete server
```
cd ~/kvm-servers/terraform
terraform workspace select ubuntu-jammy
terraform destroy
```
