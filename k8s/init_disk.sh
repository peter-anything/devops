#!/usr/bin/env bash
DISK="/dev/sdb"
# Zap the disk to a fresh, usable state (zap-all is important, b/c MBR has to be clean)
# You will have to run this step for all disks.
sgdisk --zap-all $DISK
mkfs.xfs $DISK

mkdir -p /ceph/rbd

mount -t xfs /dev/sdb /ceph/rbd