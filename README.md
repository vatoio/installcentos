Install RedHat OKD 4.0 on your own server.  For a local only install, it is suggested that you use CDK or MiniShift instead of this repo.

This install method is targeted for 3 node worker, 1 node master that has a long life.

**Please do use a clean CentOS system, the script installs all necesary tools and packages including Ansible, container runtime, etc.**

## Installation

1. ssh-keygen and ssh-copy-id to each work and master, P/S: ssh-copy-id to current ssh too

3. Download & unzip

```
curl -LOk https://github.com/vatoio/openshift-centos/archive/master.zip
yum install -y unzip
unzip master.zip
```

3. config `master` and `worker` in `01-config-update.sh`

3. execute `02-install-requirements.sh` for all worker and master

4. execute the installation `20-install-openshift.sh` script on guest machine
