CN_first=$1
CN_last=$2
trace_per_CN=10
nfs_dir=/nfs/
vm_dir=/mydata/vm_images/
vm_config_dir=/local/repository/config/vm/
net_config_dir=/local/repository/config/network/
trace_dir=/mydata/traces/
default_net=192.168.122.0/24
#apps="tf gc ma mc"
apps="ma"
syss="mind gam fastswap"

#change sudo
#echo 'Yanpeng   ALL=(ALL) NOPASSWD:/usr/bin/virsh, /sbin/ip' | sudo EDITOR='tee -a' visudo

#install virsh and nfs
sudo apt install qemu-kvm libvirt-bin bridge-utils virtinst nfs-kernel-server

#create default network
sudo virsh net-destroy default
sudo virsh net-undefine default
sudo virsh net-create --file ${net_config_dir}default.xml