#!/bin/bash

ins_path=`cat /root/tenon.path`
prikey=`grep '^prikey=' $ins_path/node/conf/lego.conf | awk -F'=' '{print $2}'`
echo -e "\033[32m"$prikey"\033[0m"
