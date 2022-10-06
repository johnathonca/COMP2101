#!/bin/bash

#gathering data
#create variable for hostname
fqdn=$(hostname -f)

#variable for operating system and version
source /etc/os-release

#variable for ip
ip=$(hostname -I)


#variable for freespace in root system
freespace=$(df -h --output=avail / | grep Avail -v)

#template
cat <<eof

Report lab 2 for $HOSTNAME
==============
FQDN: $fqdn
Operating System name and version: $PRETTY_NAME
IP Address: $ip
Root Filesystem Free Space: $freespace
==============
eof
