nodes="c1:10 c2:11 c3:12 w1:13 w2:14 w3:15"

virsh net-define k0s-net.xml
virsh net-start k0s-net
virsh net-autostart k0s-net

for node in $nodes; do
  name=$(echo $node | cut -d":" -f1)
  ip=$(echo $node | cut -d":" -f2)
  [[ -f vms/$name.qcow2 ]] || cp iso/noble-server-cloudimg-amd64.img vms/$name.qcow2
  qemu-img resize vms/$name.qcow2 +5G
  sed -r "s/%NODE%/$name/" user-data.tpl > configs/$name-user.txt
  sed -r "s/%IP%/10.0.0.$ip/" net-data.tpl > configs/$name-net.txt
  #cloud-localds configs/seed-$name.iso configs/$name.txt 
  virt-install \
    --virt-type kvm \
    --name $name \
    --ram 2048 \
    --vcpus 2 \
    --disk path=vms/$name.qcow2,bus=virtio,size=10,format=qcow2 \
    --cloud-init user-data=configs/$name-user.txt \
    --os-variant=linux2022 \
    --network network=k0s-net \
    --boot hd,cdrom --noautoconsole
done

    #,network-config=configs/$name-net.txt \
    #--disk path=configs/seed-$name.iso,device=cdrom \
