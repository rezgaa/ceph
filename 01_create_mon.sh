#!/usr/bin/env bash


# define usage function
display_usage() {
echo -en "
\033[1m

This script must be run with super-user privileges.

Usage: # 00_creating_first_mon 123.456.789.123

\n
\033[0m
"
tput sgr0                               # Reset attributes.

}


action () {
  IP="$1"
  HOSTNAME=$(hostname)
#2. adding monitors:
  scp root@ceph01:/etc/ceph/ceph.client.admin.keyring /etc/ceph && \
  scp root@ceph01:/etc/ceph/ceph.conf /etc/ceph && \
  ceph auth get mon. -o /tmp/ceph.mon.keyring && \
  ceph mon getmap -o /tmp/monmap && \
  chown ceph:ceph /tmp/ceph.mon.keyring && \
  chown ceph:ceph /tmp/monmap && \
  sudo -u ceph mkdir -p /var/lib/ceph/mon/ceph-${HOSTNAME} && \
  sudo -u ceph ceph-mon -i ${HOSTNAME} --mkfs --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring && \
  sudo -u ceph touch /var/lib/ceph/mon/ceph-${HOSTNAME}/done && \
  ceph mon add ${HOSTNAME} ${IP} && \
  systemctl start ceph-mon@${HOSTNAME}
}


# if less than two arguments supplied, display usage 
if [[ ( -z "$1" )  || ( $1 == "--help" ) ||  $1 == "-h" ]] ; then
  display_usage
  exit 1;
else
  action
fi
# display usage if the script is not run as root user 
if [[ $USER != "root" ]]; then
  echo "This script must be run as root!" 
  exit 1
fi

