target_sys=$1
CN_first=$2
CN_last=$3
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
for i in $(seq ${CN_first} ${CN_last}); do
    for sys in ${syss}; do
        sudo virsh destroy ${sys}_CN${i}
        sudo virsh undefine ${sys}_CN${i}
    done
    sudo virsh create ${vm_config_dir}${sys}_CN${i}.xml
    sleep 10
done