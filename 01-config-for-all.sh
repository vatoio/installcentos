# First you should create ssh key for each node , then ssh-copy-id all node together
export IP_MASTER="192.168.22.100"
export IP_WORKER_1="192.168.22.101"
export IP_WORKER_2="192.168.22.102"
export IP_WORKER_3="192.168.22.103"

export DOMAIN=$(curl -s ipinfo.io/ip).nip.io
export API_PORT="8443"
export USERNAME="root"
export PASSWORD="put-your-password-here"

# openshift-ansible / openshift
export VERSION="4.1"
export METRICS="True"
export LOGGING="True"

# docker storage
#export DISK="/dev/sda"

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