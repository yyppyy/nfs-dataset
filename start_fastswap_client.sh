trace_per_CN=2
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
#REPO_DIR=/local/repository/
#sudo virsh net-define --file ${REPO_DIR}default.xml
#sudo virsh net-start default


#localize vm images
echo "localizing vm images"
sudo mkdir -p ${vm_dir}
sudo cp ${nfs_dir}vm_images/fastswap_client.qcow2 ${vm_dir}


#localize traces
echo "localizing traces"
sudo mkdir -p -m 777 ${trace_dir}
trace_first=0
trace_last=$((${trace_per_CN} - 1))
for app in ${apps}; do
    sudo mkdir -p -m 777 ${trace_dir}${app}_traces
    for i in $(seq ${trace_first} ${trace_last}); do
        sudo cp ${nfs_dir}${app}_traces/${i} ${trace_dir}${app}_traces/ &
    done
done
wait


#create VM
echo "creating vms"
sudo virsh create ${vm_config_dir}fastswap_client.xml
sleep 10
#for i in $(seq ${CN_first} ${CN_last}); do
#    sudo virt-install --name ubuntu_CN${i} --memory ${vm_mem} --vcpus ${vm_vcpus} --disk ${vm_dir}ubuntu_CN_${i}.qcow --import --network default --os-variant ubuntu18.04 --noautoconsole &
#done
#wait


#create local nfs to feed data to vms
echo "building NFS"
echo "${trace_dir}  ${default_net}(rw,sync,no_subtree_check)" | sudo tee /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
#sudo ufw allow from ${default_net} to any port nfs
#sudo ufw enable
