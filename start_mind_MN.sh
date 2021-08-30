nfs_dir=/nfs/
vm_dir=/mydata/vm_images/
vm_config_dir=/local/repository/config/vm/
trace_dir=/mydata/traces/
default_net=192.168.122.0/24
#apps="tf gc ma mc"
apps="ma"

#change sudo
#echo 'Yanpeng   ALL=(ALL) NOPASSWD:/usr/bin/virsh, /sbin/ip' | sudo EDITOR='tee -a' visudo

#install virsh and nfs
sudo apt install qemu-kvm libvirt-bin bridge-utils virtinst nfs-kernel-server
#enter a Y later... see the example below
#echo "Y Y N N Y N Y Y N" | ./your_script


#create default network
sudo virsh net-destroy default
sudo virsh net-undefine default
sudo virsh net-create --file ${net_config_dir}default.xml


#localize vm images
echo "localizing vm images"
sudo mkdir -p ${vm_dir}
sudo cp ${nfs_dir}vm_images/ubuntu_MN.qcow2 ${vm_dir}


#create VM
echo "creating vms"
sudo virsh create ${vm_config_dir}ubuntu_MN.xml
sleep 10
#for i in $(seq ${CN_first} ${CN_last}); do
#    sudo virt-install --name ubuntu_CN${i} --memory ${vm_mem} --vcpus ${vm_vcpus} --disk ${vm_dir}ubuntu_CN_${i}.qcow --import --network default --os-variant ubuntu18.04 --noautoconsole &
#done
#wait

