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

# Install CertBot
yum install --enablerepo=epel -y certbot

# Configure Let's Encrypt certificate
certbot certonly --manual \
        --preferred-challenges dns \
        --email developer@$DOMAIN \
        --server https://acme-v02.api.letsencrypt.org/directory \
        --agree-tos \
        -d $DOMAIN \
        -d *.$DOMAIN \
        -d *.apps.$DOMAIN
	
## Modify inventory-tmp.ini 
# Declare usage of Custom Certificate
# Configure Custom Certificates for the Web Console or CLI => Doesn't Work for CLI
# Configure a Custom Master Host Certificate
# Configure a Custom Wildcard Certificate for the Default Router
# Configure a Custom Certificate for the Image Registry
## See here for more explanation: https://docs.okd.io/latest/install_config/certificate_customization.html
cat <<EOT >> inventory-tmp.ini
	
	openshift_master_overwrite_named_certificates=true
	
	openshift_master_cluster_hostname=console-internal.${DOMAIN}
	openshift_master_cluster_public_hostname=console.${DOMAIN}
	
	openshift_master_named_certificates=[{"certfile": "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem", "keyfile": "/etc/letsencrypt/live/${DOMAIN}/privkey.pem", "cafile": "/etc/letsencrypt/live/${DOMAIN}/chain.pem", "names": ["console.${DOMAIN}"]}]
	
	openshift_hosted_router_certificate={"certfile": "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem", "keyfile": "/etc/letsencrypt/live/${DOMAIN}/privkey.pem", "cafile": "/etc/letsencrypt/live/${DOMAIN}/chain.pem"}
	
	openshift_hosted_registry_routehost=registry.apps.${DOMAIN}
	openshift_hosted_registry_routecertificates={"certfile": "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem", "keyfile": "/etc/letsencrypt/live/${DOMAIN}/privkey.pem", "cafile": "/etc/letsencrypt/live/${DOMAIN}/chain.pem"}
	openshift_hosted_registry_routetermination=reencrypt
EOT
	
# Add Cron Task to renew certificate
echo "@weekly  certbot renew --pre-hook=\"oc scale --replicas=0 dc router\" --post-hook=\"oc scale --replicas=1 dc router\"" > certbotcron
crontab certbotcron
rm certbotcron

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
