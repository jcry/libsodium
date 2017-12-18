#!/bin/bash
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"


check_system(){
	[[ ! -z "`cat /etc/issue | grep -iE "debian"`" ]] && release="debian"
	[[ ! -z "`cat /etc/issue | grep -E -i "ubuntu"`" ]] && release="ubuntu"
	[[ ! -z "`cat /etc/redhat-release | grep -E -i "CentOS"`" ]] && release="CentOS"
	if [[ "${release}" = "debian" || "${release}" = "ubuntu" ]]; then
		 echo -e "${Info} system is ${release} " && apt-get update && apt-get install -y build-essential
	elif [[ "${release}" = "CentOS" ]]; then
		 echo -e "${Info} system is CentOS " && yum update && yum groupinstall -y "Development Tools"
	else
		 echo -e "${Error} not support system !" && exit 1
	fi
}

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

directory(){
	[[ ! -d /home/libsodium-compile ]] && mkdir -p /home/libsodium-compile
	cd /home/libsodium-compile
}

maker(){
	wget https://raw.githubusercontent.com/nanqinlang-script/libsodium/master/libsodium-1.0.15.tar.gz && tar -zxf libsodium-1.0.15.tar.gz
	chmod -R 7777 /home/libsodium-compile
	cd libsodium-1.0.15
	./configure && make -j4 && make install && ldconfig
}

check_install(){
	if [[ $? -ne 0 ]]; then
		 echo -e "${Error} libsodium installed failed, please check !"
	else
		 echo -e "${Info} libsodium installed successfully !"
	fi
}


check_root
check_system
directory
maker
check_install
rm -rf /home/libsodium-compile