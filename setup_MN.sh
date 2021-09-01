target_sys=$1
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

#create VM
echo "creating vms"
for sys in ${syss}; do
    sudo virsh destroy ${sys}_MN
    sudo virsh undefine ${sys}_MN
done
sudo virsh create ${vm_config_dir}${target_sys}_MN.xml
sleep 10
