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


#localize vm images
echo "localizing vm images"
sudo mkdir -p ${vm_dir}
for sys in ${syss}; do
    if [ ${sys} == "fastswap" ]; then
        sudo cp ${nfs_dir}vm_images/fastswap_client.qcow2 ${vm_dir} &
    elif [ ${sys} == "gam" ]; then
        for i in $(seq ${CN_first} ${CN_last}); do
            sudo cp ${nfs_dir}vm_images/gam_CN_1.qcow2 ${vm_dir}gam_CN_${i}.qcow2 &
        done
    else
        for i in $(seq ${CN_first} ${CN_last}); do
            sudo cp ${nfs_dir}vm_images/ubuntu_CN_${i}.qcow ${vm_dir} &
        done
    fi
done
wait


#localize traces
echo "localizing traces"
sudo mkdir -p -m 777 ${trace_dir}
trace_first=$((${CN_first} * ${trace_per_CN} - ${trace_per_CN}))
trace_last=$((${CN_first} * ${trace_per_CN} - 1))
for app in ${apps}; do
    sudo mkdir -p -m 777 ${trace_dir}${app}_traces
    for i in $(seq ${trace_first} ${trace_last}); do
        sudo cp ${nfs_dir}${app}_traces/${i} ${trace_dir}${app}_traces/ &
    done
done
wait


#create local nfs to feed data to vms
echo "building NFS"
echo "${trace_dir}  ${default_net}(rw,sync,no_subtree_check)" | sudo tee /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
#sudo ufw allow from ${default_net} to any port nfs
#sudo ufw enable
