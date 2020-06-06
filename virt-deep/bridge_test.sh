ip link add name br0 type bridge
ip link set br0 up
ip link add veth0 type veth peer name veth1
ip addr add 1.2.3.101/24 dev br0
ip addr add 1.2.3.102/24 dev veth1
ip link set veth0 up
ip link set veth1 up
ip link set dev veth0 master br0