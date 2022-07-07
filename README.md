# DNS-in-namespaces
Playing with DNS in linux network namespaces using BIND

### Topology
![Topo](https://user-images.githubusercontent.com/72434180/177760566-11e35d13-e349-4c93-bff7-aedd7c69b04d.png)

- Follow [this article](https://ba1ajinaidu.hashnode.dev/how-to-configure-bind-as-a-private-network-dns-server-on-linux-network-namespaces) and setup directories in `/etc/netns/<namespace-name>` for the above topology and place the bind directories from this repo into their respective namespace directories.
- After setting up the directories run `env.sh` to setup the topology. Edit the resolv.conf files in host and local_ns exec'ing into the namespaces.

Now try running a dig request from `host` namespace to get records of `ns1.test.tcl`. 
