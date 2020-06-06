#!/bin/bash

mkdir -p /var/lib/etcd
mkdir -p /etc/etcd/
useradd etcd -d /var/lib/etcd -c "Etcd user" -r -s /sbin/nologin
chown etcd:etcd -R /var/lib/etcd

cat > "/usr/lib/systemd/system/etcd.service" <<EOF
[Unit]
Description=Etcd Service
After=network.target

[Service]
Environment=ETCD_DATA_DIR
EnvironmentFile=-/etc/etcd/etcd.conf
Type=notify
User=etcd
WorkingDirectory=/var/lib/etcd
PermissionsStartOnly=true
ExecStart=/usr/local/bin/etcd
Restart=on-failure
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl restart sshd

sed -i "s/files dns myhostname/files/g"  /etc/nsswitch.conf