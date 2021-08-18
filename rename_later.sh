num_CNs=1
nfs_dir=/nfs/
vm_dir=/mydata/vm_images/
vm_mem=8192
vm_vcpus=10

#install virsh
sudo apt install qemu-kvm libvirt-bin bridge-utils virtinst
#enter a Y later... see the example below
#echo "Y Y N N Y N Y Y N" | ./your_script

#create default network
#REPO_DIR=/local/repository/
#sudo virsh net-define --file ${REPO_DIR}default.xml
#sudo virsh net-start default

#localize vm images
sudo mkdir -p $vm_dir
for i in $(seq 1 ${num_CNs}); do
    sudo cp ${nfs_dir}vm_images/ubuntu_CN_${i}.qcow ${vm_dir}
done

#create VM
for i in $(seq 1 $num_CNs); do
    sudo virt-install --name ubuntu_CN${i} --memory ${vm_mem} --vcpus ${vm_vcpus} --disk ${vm_dir}ubuntu_CN_${i}.qcow --import --network default
done
