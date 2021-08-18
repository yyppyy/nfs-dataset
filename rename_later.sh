#install virsh
sudo apt install qemu-kvm libvirt-bin bridge-utils virtinst
#enter a Y later...

#create default network
#REPO_DIR=/local/repository/
#sudo virsh net-define --file ${REPO_DIR}default.xml
#sudo virsh net-start default

#create VM
num_CNs=1
for i in $(seq 1 $num_CNs); do
    sudo virt-install --name ubuntu_CN$i --memory 8192 --vcpus 10 --disk /nfs/vm_images/ubuntu_CN_$i.qcow --network default
done
