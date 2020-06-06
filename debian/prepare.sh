#!/bin/bash

#关闭Swapp
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab

#修改转发配置
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness = 0
EOF

sysctl --system

iptables -P FORWARD ACCEPT

modprobe ip_vs
modprobe ip_vs_rr
modprobe ip_vs_wrr
modprobe ip_vs_sh
modprobe nf_conntrack_ipv4