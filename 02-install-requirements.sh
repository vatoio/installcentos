#!/bin/bash
source 01-config-update.sh

# ======== WARNING - DO NOT MODIFY ANYLINE BELLOW THIS EXCEPT YOU KNOW WHAT ITS MEAN ===========

# install updates
yum update -y

# install the following base packages
yum install -y  wget git zile nano net-tools docker-1.13.1\
	bind-utils iptables-services \
	bridge-utils bash-completion \
	kexec-tools sos psacct openssl-devel \
	httpd-tools NetworkManager \
	python-cryptography python2-pip python-devel  python-passlib \
	java-1.8.0-openjdk-headless "@Development Tools"

#install epel
yum -y install epel-release

# Disable the EPEL repository globally so that is not accidentally used during later steps of the installation
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

systemctl | grep "NetworkManager.*running" 
if [ $? -eq 1 ]; then
	systemctl start NetworkManager
	systemctl enable NetworkManager
fi

cat <<EOD > /etc/hosts
127.0.0.1                  localhost
::1                        localhost
${IP_MASTER}              master console.${DOMAIN}
${IP_WORKER_1}             worker1
${IP_WORKER_2}             worker2
${IP_WORKER_3}             worker3
EOD

if [ -z $DISK ]; then 
	echo "Not setting the Docker storage."
else
	cp /etc/sysconfig/docker-storage-setup /etc/sysconfig/docker-storage-setup.bk

	echo DEVS=$DISK > /etc/sysconfig/docker-storage-setup
	echo VG=DOCKER >> /etc/sysconfig/docker-storage-setup
	echo SETUP_LVM_THIN_POOL=yes >> /etc/sysconfig/docker-storage-setup
	echo DATA_SIZE="100%FREE" >> /etc/sysconfig/docker-storage-setup

	systemctl stop docker

	rm -rf /var/lib/docker
	wipefs --all $DISK
	docker-storage-setup
fi

systemctl restart docker
systemctl enable docker