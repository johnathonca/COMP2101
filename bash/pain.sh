#!/bin/bash

# This is my testing script.
# use the which command to check if lxd is on the system.
which lxd >/dev/null
if [ $? -ne 0 ]; then
        #Install lxd
        echo "Need to install lxd, you may need to enter password"
        sudo snap install lxd
        if [ $? -ne 0 ]; then
        #failed to install lxd - error message and exit
                echo "Failed to install lxd software, which is needed."
                exit 1
        fi
fi

#lxd software install complete/lxd is on the system.

if [ $? -eq 0 ]; then
        echo "lxd is installed already/finished installing"
fi
#tested and working

#do we have the lxdbr0 interface?
ifconfig | grep lxdbr0
if [ $? -ne 0 ]; then
        lxd init --auto
fi
#if we have lxdbr0 good next step.
if [ $? -eq 0 ]; then
        echo 'lxdbr0 is installed already/finished installing'
fi

#check if COMP2101-S22 exists
sudo ls /var/snap/lxd/common/lxd/containers | grep COMP -q
if [ $? -ne 0 ]; then
        lxc launch ubuntu:20.04 COMP2101-S22
fi
if [ $? -eq 0 ]; then
        echo 'COMP2101-S22 containter exists/has been made'
fi

#get ip for /etc/hosts
ipget=$(lxc list | grep -w -v lxbr0 | awk '{print $6}' | grep -v IPV4 | grep "\S")
sudo -- sh -c "echo $ipget '   COMP2101-S22' >> /etc/hosts"
#setting public ip
myip=$(dig +short myip.opendns.com @resolver1.opendns.com)

#set up apache webserver if not installed
lxc exec COMP2101-S22 -- service apache2 status > /dev/null
if [ $? -ne 0 ]; then
        lxc exec COMP2101-S22 -- apt update
        lxc exec COMP2101-S22 -- apt install apache2
fi
if [ $? -eq 0 ]; then
        echo 'Appache2 is already installed'
fi
PORT=80 PUBLIC_IP=$myip CONTAINER_IP=$ipget sudo -E bash -c 'iptables -t nat -I PREROUTING -i eth0 -p TCP -d $PUBLIC_IP --dport $PORT -j DNAT --to-destination $CONTAINER_IP:$PORT -m comment --comment "forward to the Apache2 container"'

#keep the iptables and check if its installed
sudo dpkg -l iptables-persistent | grep -q iptables-persistent
if [ $? -ne 0 ]; then
        sudo apt install iptables-persistent
fi
if [ $? -eq 0 ]; then
        echo 'iptables-persistent is already installed/finished installing'
fi

#show containers webpage and check if curl is installed
sudo apt install curl ; curl -s http://COMP2101-S22 > /dev/null



if [ $? -eq 0 ]; then
        echo  "Successfully pulled container webpage"
fi
if [ $? -ne 0 ]; then 
        echo "failed to pull container webpage"
fi

