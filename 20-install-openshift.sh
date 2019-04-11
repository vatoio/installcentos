#!/bin/bash
source 01-config-update.sh

# install the packages for Ansible

yum install -y epel-release pyOpenSSL python-cryptography python-lxml

if [ ! -f ansible.rpm ]; then
    curl -o ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-${ANSIBLE_VERSION}-1.el7.ans.noarch.rpm
    yum -y --enablerepo=epel install ansible.rpm
fi

[ ! -d openshift-ansible ] && git clone https://github.com/openshift/openshift-ansible.git -b release-${VERSION} --depth=1

envsubst < inventory-template.ini > inventory-tmp.ini

ansible-playbook -i inventory-tmp.ini openshift-ansible/playbooks/prerequisites.yml
ansible-playbook -i inventory-tmp.ini openshift-ansible/playbooks/deploy_cluster.yml

mkdir -p /etc/origin/master/
touch /etc/origin/master/htpasswd

htpasswd -b /etc/origin/master/htpasswd ${USERNAME} ${PASSWORD}
oc adm policy add-cluster-role-to-user cluster-admin ${USERNAME}

echo "******"
echo "* Your console is https://console.$DOMAIN:$API_PORT"
echo "* Your username is $USERNAME "
echo "* Your password is $PASSWORD "
echo "*"
echo "* Login using:"
echo "*"
echo "$ oc login -u ${USERNAME} -p ${PASSWORD} https://console.$DOMAIN:$API_PORT/"
echo "******"

oc login -u ${USERNAME} -p ${PASSWORD} http://console.$DOMAIN:$API_PORT/
