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


action() {
  echo -en "Yes, creating osd \n "
  IP="$1"
  HOSTNAME=$(hostname) 
  ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *' && \
  ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow' && \
  ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring && \
  monmaptool --create --add ${HOSTNAME} ${IP} --fsid ${UUID} /tmp/monmap && \
  sudo -u ceph mkdir -p /var/lib/ceph/mon/ceph-${HOSTNAME} && \
  chown ceph:ceph /tmp/ceph.mon.keyring && \
  sudo -u ceph ceph-mon --mkfs -i ${HOSTNAME} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring && \
  sudo -u ceph touch /var/lib/ceph/mon/ceph-${HOSTNAME}/done && \
  ceph-mon -i cnode01 --public-addr 192.168.2.201 && \
  #ceph mon add ceph02 172.26.183.232
  systemctl enable ceph-mon@${HOSTNAME} && \
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

