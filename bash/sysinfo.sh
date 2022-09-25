#!/bin/bash
#Every blank echo is a space for tidiness

#Print out the FQDN infomation
echo FQDN: $(hostname)

echo  
#Host info
echo  host info: 
hostnamectl

echo  
echo IP address:
hostname -I

echo  
#Display space available in root filesystem
echo Rootfile System Status:
df ~/COMP2101/bash -BG
