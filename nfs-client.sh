host="192.168.1.1"
host_dir="/mydata"
mnt_dir="/traces"

sudo mkdir -p -m 777 $mnt_dir
sudo mount $host:$host_dir  $mnt_dir
