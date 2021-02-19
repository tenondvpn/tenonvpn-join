#!/bin/bash

ins_path=`cat /root/tenon.path`
id=`grep '^id=' $ins_path/node/conf/lego.conf | awk -F'=' '{print $2}'`
echo -e "\033[32mhttps://www.tenonvpn.net/transaction/"$id"\033[0m"
