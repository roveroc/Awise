#!/bin/sh

#  ipScanner.sh
#  AwiseController
#
#  Created by rover on 16/5/17.
#  Copyright © 2016年 rover. All rights reserved.


#!/bin/bash
#Author: kashu
#Date: 2013-08-20
#Filename: ip_scan_arp.sh
#Description: ip scan (ARP protocol)

NIC=eth1
tmp_list=/tmp/ip_scan_arp.list
ip_list=./ip_scan_arp.list
>$tmp_list
>$ip_list
ip_addr="`ip -4 -o ad s $NIC | awk '{print $4}' | cut -d'.' -f1-3`."
for i in {1..254}; do
{
sudo arping -I $NIC -q -f -c3 "${ip_addr}""${i}" && echo "${ip_addr}""${i}" >> $tmp_list
} &
done
wait
sort -nuk4 -t'.' $tmp_list >> $ip_list
my_ip="`ip -4 -o ad s $NIC | awk '{print $4}' | cut -d'/' -f1`"
sed -i "/${my_ip}/d" $ip_list
cat $ip_list