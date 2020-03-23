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

cat > "/etc/yum.repos.d/CentOS-OpenStack-Rocky.repo" <<EOF
[centos-openstack-rocky]
name=CentOS-7 - OpenStack rocky
baseurl=http://mirrors.aliyun.com/centos/7/cloud/x86_64/openstack-rocky/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud

[centos-openstack-rocky-test]
name=CentOS-7 - OpenStack rocky Testing
baseurl=http://mirrors.aliyun.com/centos/7/cloud/x86_64/openstack-rocky/
gpgcheck=0
enabled=0

[centos-openstack-rocky-debuginfo]
name=CentOS-7 - OpenStack rocky - Debug
baseurl=http://mirrors.aliyun.com/centos/7/cloud/x86_64/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud

[centos-openstack-rocky-source]
name=CentOS-7 - OpenStack rocky - Source
baseurl=http://mirrors.aliyun.com/centos/7/cloud/x86_64/openstack-rocky/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud

[rdo-trunk-rocky-tested]
name=OpenStack rocky Trunk Tested
baseurl=http://mirrors.aliyun.com/centos/7/cloud/x86_64/rdo-trunk-rocky-tested/
gpgcheck=0
enabled=0
EOF

yum update -y

yum install python-openstackclient openstack-selinux -y
