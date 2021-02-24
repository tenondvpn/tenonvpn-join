#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

prevwd=`pwd`
cp ./fast_net.sh /etc/rc.d/init.d/fast_net.sh
chmod +x /etc/rc.d/init.d/fast_net.sh
cd /etc/rc.d/init.d/ && chkconfig --add fast_net.sh && chkconfig fast_net.sh on
cd $prevwd

if [ $# != 2 ] ; then
    ins_path=`pwd`
    min_port=0
    second_port=0
    third_port=0
    max_port=0
    sed -i -e 's/replace_min_port/'$min_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_second_port/'$second_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_third_port/'$third_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_max_port/'$max_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_vpn_server_port/1/g' $ins_path/node/conf/lego.conf
else
    ins_path=`pwd`
    min_port=$1
    second_port=`expr $1 + 1`
    third_port=`expr $1 + 2`
    max_port=$2
    sed -i -e 's/replace_min_port/'$min_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_second_port/'$second_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_third_port/'$third_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_max_port/'$max_port'/g' $ins_path/node/conf/lego.conf
    sed -i -e 's/replace_vpn_server_port/0/g' $ins_path/node/conf/lego.conf
fi

install() {
    if [[ "${release}" == "centos" ]]; then
        sudo sh centos_env.sh
    else
        echo "just support centos7."
        exit 1
        sudo bash general_env.sh
    fi
}

check_sys
install
