# Cleanup
sudo ip -all netns delete

# Setup topology
sudo ip netns add host
sudo ip netns add local_ns
sudo ip netns add root_ns
sudo ip netns add auth_ns

sudo ip link add veth0 type veth peer name veth1
sudo ip link add veth2 type veth peer name veth3
sudo ip link add veth4 type veth peer name veth5

sudo ip link set veth0 netns host
sudo ip link set veth1 netns local_ns
sudo ip link set veth2 netns local_ns
sudo ip link set veth3 netns root_ns
sudo ip link set veth4 netns root_ns
sudo ip link set veth5 netns auth_ns

# Assign IP addresses
sudo ip netns exec host ip addr add 10.0.1.2/24 dev veth0
sudo ip netns exec local_ns ip addr add 10.0.1.3/24 dev veth1
sudo ip netns exec local_ns ip addr add 10.1.1.2/24 dev veth2
sudo ip netns exec root_ns ip addr add 10.1.1.3/24 dev veth3
sudo ip netns exec root_ns ip addr add 10.0.0.2/24 dev veth4
sudo ip netns exec auth_ns ip addr add 10.0.0.3/24 dev veth5

# Bring the interfaces online
sudo ip netns exec host ip link set dev veth0 up
sudo ip netns exec local_ns ip link set dev veth1 up
sudo ip netns exec local_ns ip link set dev veth2 up
sudo ip netns exec root_ns ip link set dev veth3 up
sudo ip netns exec root_ns ip link set dev veth4 up
sudo ip netns exec auth_ns ip link set dev veth5 up

sudo ip netns exec host ip link set dev lo up
sudo ip netns exec local_ns ip link set dev lo up
sudo ip netns exec root_ns ip link set dev lo up
sudo ip netns exec auth_ns ip link set dev lo up

# Enable ip forwarding
sudo ip netns exec local_ns sysctl -w net.ipv4.conf.all.forwarding=1
sudo ip netns exec root_ns sysctl -w net.ipv4.conf.all.forwarding=1

# Add routes
sudo ip netns exec host ip route add default via 10.0.1.3
sudo ip netns exec local_ns ip route add default via 10.1.1.3
sudo ip netns exec root_ns ip route add default via 10.1.1.2
sudo ip netns exec auth_ns ip route add default via 10.0.0.2