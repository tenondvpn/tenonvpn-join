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
