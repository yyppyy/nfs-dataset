#install virsh
sudo apt install qemu-kvm libvirt-bin bridge-utils virtinst
#enter a Y later...

#create default network
REPO_DIR=/local/repository/
sudo virsh net-define --file ${REPO_DIR}default.xml
sudo virsh net-start default
