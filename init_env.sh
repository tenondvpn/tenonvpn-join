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

check_version(){
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
}

BBR_grub(){
	if [[ "${release}" == "centos" ]]; then
        if [[ ${version} = "6" ]]; then
            if [ ! -f "/boot/grub/grub.conf" ]; then
                echo -e "${Error} /boot/grub/grub.conf 找不到，请检查."
                exit 1
            fi
            sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
        elif [[ ${version} = "7" ]]; then
            grub2-mkconfig --output=/boot/grub2/grub.cfg 
            if [ ! -f "/boot/grub2/grub.cfg" ]; then
                echo -e "${Error} /boot/grub2/grub.cfg 找不到，请检查."
                exit 1
            fi
            grub2-set-default 0
        fi
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
        /usr/sbin/update-grub
	apt-get install -y sudo
    fi
}

installbbrplus(){
	if [[ "${release}" == "centos" ]]; then
		yum install -y ./pkgs/kernel-headers-4.14.129-bbrplus.rpm
		yum install -y ./pkgs/kernel-4.14.129-bbrplus.rpm
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		dpkg -i ./pkgs/linux-headers-4.14.129-bbrplus.deb
		dpkg -i ./pkgs/linux-image-4.14.129-bbrplus.deb
	fi
	BBR_grub
}

check_sys_bbrplus(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} -ge "6" ]]; then
			installbbrplus
		else
			echo -e "${Error} BBRplus内核不支持当前系统 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} -ge "8" ]]; then
			installbbrplus
		else
			echo -e "${Error} BBRplus内核不支持当前系统 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
		if [[ ${version} -ge "14" ]]; then
			installbbrplus
		else
			echo -e "${Error} BBRplus内核不支持当前系统 ${release} ${version} ${bit} !" && exit 1
		fi
	else
		echo -e "${Error} BBRplus内核不支持当前系统 ${release} ${version} ${bit} !" && exit 1
	fi
}

startbbrplus(){
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbrplus" >> /etc/sysctl.conf
	sysctl -p
}

keep_auto_start() {
    cp ./check_net.sh /root
    cp ./restart.sh /root
    rand_s=`tr -dc "0-9" < /dev/urandom | head -c 2`
    rand_m=`echo $rand_s | awk '{print int($0)}'`
    rand_mb=$(( $rand_m % 60 ))
    echo "* * * * * cd /root && sudo bash check_net.sh" > /var/spool/cron/root
    echo "${rand_mb} 13 * * * cd /root && sudo bash restart.sh" >> /var/spool/cron/root
    crontab -u root /var/spool/cron/root
}

cp_bin() {
    if [[ "${release}" == "centos" ]]; then
        cp ./pkgs/centos/net ./node
        yum install -y net-tools
    elif [[ "${release}" == "debian" ]]; then
        cp ./pkgs/debian9/net ./node
        cp ./pkgs/lib*.so* ./node
        apt-get install -y net-tools
    elif [[ "${release}" == "ubuntu" ]]; then
        cp -rf ./pkgs/debian9/net ./node
	cp -rf ./pkgs/lib*.so* ./node	
        apt-get install -y net-tools
    else
        echo "not support."
    fi
}

check_install_path() {
    ins_path=`pwd`
    echo $ins_path > /root/tenon.path
}

check_sys
echo ${release}
check_version
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && exit 1
check_sys_bbrplus
startbbrplus
check_install_path
keep_auto_start
cp_bin
reboot
