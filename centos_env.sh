#!/bin/bash

#yum install -f wget gcc gcc-c++ gcc-g77 flex bison autoconf automake bzip2-devel zlib-devel ncurses-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel pam-devel openssl-devel libxml2-devel gettext-devel pcre-devel

check_system(){
	[[ -z "`cat /etc/redhat-release | grep -iE "CentOS"`" ]] && echo -e "${Error} only support CentOS !" && exit 1
	[[ ! -z "`cat /etc/redhat-release | grep -iE " 7."`" ]] && bit=7
	[[ ! -z "`cat /etc/redhat-release | grep -iE " 6."`" ]] && bit=6
	[[ "`uname -m`" != "x86_64" ]] && echo -e "${Error} only support 64bit !" && exit 1
}

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

check_kvm(){
	yum update -y
	yum install -y virt-what net-tools
}

install_image(){
	yum  install -y ./kernel/kernel-ml-4.12.10-1.el7.elrepo.x86_64.rpm
}
install_devel(){
	yum  install -y ./kernel/kernel-ml-devel-4.12.10-1.el7.elrepo.x86_64.rpm
}
install_headers(){
	yum  install -y ./kernel/kernel-ml-headers-4.12.10-1.el7.elrepo.x86_64.rpm
}

update_grub(){
	[[ "${bit}" = "7" ]] && grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-set-default 0
	[[ "${bit}" = "6" ]] && sed -i '/default=/d' /boot/grub/grub.conf && echo -e "\ndefault=0\c" >> /boot/grub/grub.conf
}

check_kernel(){
	already_image=`rpm -qa | grep kernel-4.12.10`
	already_devel=`rpm -qa | grep kernel-devel-4.12.10`
	already_headers=`rpm -qa | grep kernel-headers-4.12.10`

	delete_surplus_1

	if [[ -z "${already_image}" ]]; then
		 echo -e "${Info} installing image" && install_image
	else echo -e "${Info} noneed install image"
	fi

	if [[ -z "${already_devel}" ]]; then
		 echo -e "${Info} installing devel" && install_devel
	else echo -e "${Info} noneed install devel"
	fi

	if [[ -z "${already_headers}" ]]; then
		 echo -e "${Info} installing headers" && install_headers
	else echo -e "${Info} noneed install headers"
	fi

	update_grub
}

init_config(){
    echo "fs.file-max = 1024000" >> /etc/sysctl.conf
    echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
    echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf
    echo "net.core.rmem_default = 65536" >> /etc/sysctl.conf
    echo "net.core.wmem_default = 65536" >> /etc/sysctl.conf
    echo "net.core.netdev_max_backlog = 4096" >> /etc/sysctl.conf
    echo "net.core.somaxconn = 4096" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_tw_recycle = 0" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_time = 1200" >> /etc/sysctl.conf
    echo "net.ipv4.ip_local_port_range = 10000 65000" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_syn_backlog = 4096" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_rmem = 4096 87380 67108864" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_wmem = 4096 65536 67108864" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = hybla" >> /etc/sysctl.conf
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf

    echo "*               soft    nofile           512000" >> /etc/security/limits.conf
    echo "*               hard    nofile          1024000" >> /etc/security/limits.conf

    echo "session required pam_limits.so" >> /etc/pam.d/common-session

    echo "ulimit -SHn 1024000" >> /etc/profile
}

init_firewall() {
    iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
}

check_install_path() {
    ins_path=`pwd`
    echo $ins_path > /root/tenon.path
}

keep_auto_start() {
    cp ./check_net.sh /root
    cp ./restart.sh /root
    cp ./pkgs/centos/net ./node/
    rand_s=`tr -dc "0-9" < /dev/urandom | head -c 2`
    rand_m=`echo $rand_s | awk '{print int($0)}'`
    rand_mb=$(( $rand_m % 60 ))
    echo "* * * * * cd /root && sudo sh check_net.sh" >> /var/spool/cron/root
    echo "${rand_mb} * * * * cd /root && sudo sh restart.sh" >> /var/spool/cron/root
}

install(){
        check_install_path
	check_system
	check_root
	check_kvm
	check_kernel
	init_config
	init_firewall
        keep_auto_start
	reboot
}

install
