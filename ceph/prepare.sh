#!/bin/bash

systemctl stop firewalld.service
systemctl disable firewalld.service

setenforce 0
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux

yum install chrony -y

cat > "/etc/chrony.conf" <<EOF
server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
allow 192.168.0.0/24
EOF

systemctl restart chronyd.service
systemctl enable chronyd.service

timedatectl set-timezone Asia/Shanghai
chronyc sources

yum install -y wget

mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum clean all
yum makecache
yum update -y