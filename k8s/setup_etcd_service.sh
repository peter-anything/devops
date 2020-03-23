#!/bin/bash

ARGS=`getopt -o h --long initial-cluster:,peer-port:,client-port: \
    -n 'test.bash' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

#set 会重新排列参数的顺序，也就是改变$1,$2...$n的值，这些值在getopt中重新排列过了
eval set -- "$ARGS"

#经过getopt的处理，下面处理具体选项。
hosts=""
peer_port=0
client_port=0
ip=$(ip addr |grep 'inet'|awk {'print $2'}|grep -E '192.168|172.19'|awk -F '/' {'print $1'})

while true ; do
    case "$1" in
        --initial-cluster)
            hosts=$2
            shift 2
            ;;
        --peer-port)
            peer_port=$2; 
            shift 2
            ;;
        --client-port)
            client_port=$2;
            shift 2
            ;;
        --)
            shift;
            break
            ;;
        *)
            echo "Internal error!";
            exit 1
            ;;
    esac
done

cat > /lib/systemd/system/etcd.service <<EOF
[Unit]
Description=etcd with Docker
Documentation=https://github.com/coreos/etcd

[Service]
Restart=always
RestartSec=5s
TimeoutStartSec=0
LimitNOFILE=40000

ExecStart=/usr/bin/docker run --rm --name etcd \
--net=host \
-p $client_port:$client_port \
-p $peer_port:$client_port \
-v /data/docker/etcd/data:/var/lib/etcd \
-v /share/etc/etcd/ssl:/etc/kubernetes/pki/etcd \
k8s.gcr.io/etcd:3.4.3-0 \
/usr/local/bin/etcd \
--advertise-client-urls=https://$ip:$client_port \
--cert-file=/etc/kubernetes/pki/etcd/etcd.pem \
--key-file=/etc/kubernetes/pki/etcd/etcd-key.pem \
--client-cert-auth=true \
--data-dir=/var/lib/etcd \
--initial-advertise-peer-urls=https://$ip:$peer_port \
--initial-cluster=$hosts \
--listen-client-urls=https://0.0.0.0:$client_port \
--listen-peer-urls=https://0.0.0.0:$peer_port \
--name=$HOSTNAME \
--peer-cert-file=/etc/kubernetes/pki/etcd/etcd.pem \
--peer-client-cert-auth=true \
--peer-key-file=/etc/kubernetes/pki/etcd/etcd-key.pem \
--peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.pem \
--snapshot-count=10000 \
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.pem

ExecStop=/usr/bin/docker stop etcd

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart etcd
systemctl enable etcd