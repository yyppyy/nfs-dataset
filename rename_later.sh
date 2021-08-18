num_CNs=1
nfs_dir=/nfs/
vm_dir=/mydata/vm_images/
trace_dir=/mydata/traces/
vm_mem=8192
vm_vcpus=10
default_net=192.168.122.0/24

#change sudo
#echo 'Yanpeng   ALL=(ALL) NOPASSWD:/usr/bin/virsh, /sbin/ip' | sudo EDITOR='tee -a' visudo

#install virsh and nfs
sudo apt install qemu-kvm libvirt-bin bridge-utils virtinst nfs-kernel-server
#enter a Y later... see the example below
#echo "Y Y N N Y N Y Y N" | ./your_script


#create default network
#REPO_DIR=/local/repository/
#sudo virsh net-define --file ${REPO_DIR}default.xml
#sudo virsh net-start default



#localize vm images
sudo mkdir -p ${vm_dir}
for i in $(seq 1 ${num_CNs}); do
    sudo cp ${nfs_dir}vm_images/ubuntu_CN_${i}.qcow ${vm_dir}
done



#create VM
for i in $(seq 1 $num_CNs); do
    sudo virt-install --name ubuntu_CN${i} --memory ${vm_mem} --vcpus ${vm_vcpus} --disk ${vm_dir}ubuntu_CN_${i}.qcow --import --network default --os-variant ubuntu18.04 --noautoconsole
done



#create local nfs to feed data to vms
sudo mkdir -p -m 777 ${trace_dir}
sudo echo "${trace_dir}  ${default_net}(r,sync,no_subtree_check)" >> /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
#sudo ufw allow from ${default_net} to any port nfs
#sudo ufw enable
