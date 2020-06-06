#!/bin/bash

cat > "/etc/sysconfig/network-scripts/ifcfg-eth0" <<EOF
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=$1
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=192.168.0.1
DNS2=8.8.8.8
ONBOOT=yes
EOF

systemctl restart network