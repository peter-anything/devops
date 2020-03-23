#!/bin/bash
sudo cp k8s.conf /etc/sysctl.d/k8s.conf && sudo sysctl -p /etc/sysctl.d/k8s.conf && sudo swapoff -a
sudo kubeadm init --kubernetes-version=$(kubeadm version -o short) --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config