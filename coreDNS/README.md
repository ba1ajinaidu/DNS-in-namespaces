### DoH on linux network namespaces

Emulating and running DoH servers on linux network namespaces using [coreDNS](https://coredns.io/).

### Topology
![Topo](https://i.imgur.com/sy7VVLB.png)

### Prerequisites
- A fresh Ubuntu 20.04 machine with `iproute2` and `golang` insatlled. 
- CoreDNS [installed from source code](https://github.com/coredns/coredns#compilation-from-source)
- Install unbound plugin for coreDNS
    - ```bash
      sudo apt install libunbound-dev
      ```
    - Add unbound plugin to coreDNS by following [similar steps](https://coredns.io/2017/07/25/compile-time-enabling-or-disabling-plugins/#build-with-compile-time-configuration-file)
- Install [dnslookup](https://github.com/ameshkov/dnslookup) tool to perform DoH queries



### Setting up DoH

All the files belonging to each of the namespaces are provided in the folders that are named after the respective namespaces. Place these folders under the path `/etc/netns` . For example, `/etc/netns/t1`

Then run the env.sh bash file to setup namespaces and routes as per the topology denoted above.
```bash
sudo ./env.sh
```
##### Changes required in coreDNS folder
- Make sure that the unbound plugin is added to `plugin.cfg` file
- In Makefile of coreDNS, the `CGO_ENABLED` flag is to be set to 1 since libunbound binary will be dynamically linked to the coreDNS binary

##### TLS certificates

Generate TLS certificates by creating a self signed CA using cert-manager for `ns1.test.tcl` and store the `tls.crt` and `tls.key` files under `rec_dns/coredns/` and `ca.crt` in `t1` folder under `/etc/netns`. You can also generate TLS certificates from a trusted CA.

##### Start coreDNS
Now to test out the DoH setup, run coreDNS on `rec_dns, auth_dns` namespaces.
Run these commands where coredns executable is present(Typically present at the installation source)
```shell
sudo ip netns exec rec_dns ./coredns -conf /etc/netns/rec_dns/corefile
sudo ip netns exec auth_dns ./coredns -conf /etc/netns/auth_dns/corefile
```
##### Testing
Test the DoH setup using curl https request. Run this command from `/etc/netns/t1` directory
```shell
sudo ip netns exec t1 ./dnslookup t2.test.tcl https://ns1.test.tcl/dns-query
```

Sample response:
```bash
dnslookup v. v1.7.1
dnslookup result:
;; opcode: QUERY, status: NOERROR, id: 13013
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

;; QUESTION SECTION:
;t1.test.tcl.	IN	 A

;; ANSWER SECTION:
t1.test.tcl.	3600	IN	A	10.0.0.3
```
