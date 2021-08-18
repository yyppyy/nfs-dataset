default_net=192.168.1.0/24
trace_dir=/traces


sudo mkdir -p -m 777 ${trace_dir}
echo "${trace_dir}  ${default_net}(r,sync,no_subtree_check)" | sudo tee /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
