Install RedHat OKD 4.1 on your own server.  For a local only install, it is suggested that you use CDK or MiniShift instead of this repo.

This install method is targeted for 3 node worker, 1 node master that has a long life.

**Please do use a clean CentOS system, the script installs all necesary tools and packages including Ansible, container runtime, etc.**

## Installation

1. Download & unzip

```
curl -LOk https://github.com/vatoio/openshift-centos/archive/master.zip
yum install -y unzip
unzip master.zip
```

2. ssh-keygen and ssh-copy-id for each node and cluster, config 00-config-env.sh

3. execute 00-config-env.sh and 01-config-for-all.sh for all worker and master

4. execute the installation script on master

```
cd openshift-centos
./install-openshift.sh
```