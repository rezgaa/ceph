#!/usr/bin/env bash

HOSTNAME=$(hostname)
ceph osd create
sudo -u ceph mkdir /var/lib/ceph/osd/ceph-$1
mkfs.xfs -f -i size=2048 /dev/${2}
mount /dev/${2} /var/lib/ceph/osd/ceph-$1
chown ceph:ceph /var/lib/ceph/osd/ceph-$1
sudo -u ceph ceph-osd -i ${1} --mkfs --mkkey
ceph auth add osd.${1} osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-${1}/keyring

ceph osd crush add-bucket ${HOSTNAME} host
ceph osd crush move ${HOSTNAME} root=default
ceph osd crush add osd.${1} 1.0 host=${HOSTNAME}
#ceph osd crush reweight osd.${1} 0.13190
#ceph osd reweight-by-utilization
sudo -u ceph touch /var/lib/ceph/osd/ceph-$1/systemd
systemctl enable ceph-osd@${1}
systemctl start ceph-osd@${1}
ceph osd tree
#
#systemctl stop ceph-osd@2 && ceph-osd --flush-journal -i 2 && rm -rf /var/lib/ceph/osd/ceph-2/journal && ceph-osd --mkjournal -i 2 && systemctl start ceph-osd

