# ceph


cat > /etc/yum.repos.d/ceph.repo <<'EOG'
[ceph]
name=Ceph
baseurl=http://download.ceph.com/rpm-jewel/el$releasever/x86_64
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=http://download.ceph.com/rpm-jewel/el7/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=http://download.ceph.com/rpm-jewel/el7/SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

EOG

yum install -y ceph
