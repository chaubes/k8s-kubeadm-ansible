#!/bin/bash
set -e
IFNAME=$1
HOST_ENTRIES=$2

ETC_HOSTS_FILE=/etc/hosts
HOSTNAME=$(hostname)
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 | awk '{print $2}' | cut -d/ -f1)"

echo -e "$HOST_ENTRIES"
echo "############### BEFORE update /etc/hosts ###############" >>/tmp/data.txt
cat ${ETC_HOSTS_FILE} >> /tmp/data.txt

sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i ${ETC_HOSTS_FILE}

# remove ubuntu entry
sed -e '/^.*ubuntu.*/d' -i ${ETC_HOSTS_FILE}

# add host entries
echo "${HOST_ENTRIES}" >> ${ETC_HOSTS_FILE}

echo "############### AFTER update /etc/hosts ###############" >>/tmp/data.txt
cat ${ETC_HOSTS_FILE} >> /tmp/data.txt
