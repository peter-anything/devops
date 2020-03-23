#!/bin/bash
# step 1: 安装必要的一些系统工具
yum install -y yum-utils device-mapper-persistent-data lvm2
# step 2: 安装GPG证书
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 写入软件源信息
yum clean all
yum makecache
yum install -y docker-ce-18.06.3.ce-3.el7

systemctl start docker
systemctl enable docker
mkdir -p /etc/docker; cp daemon.json /etc/docker/daemon.json; systemctl restart docker