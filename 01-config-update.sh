#!/bin/bash

# First you should create ssh key for each node , then ssh-copy-id all node together
export MASTER_IP="192.168.22.100"
export MASTER_HOST_NAME="trunkgateway.local"

export WORKER_1_IP="192.168.22.101"
export WORKER_1_HOST_NAME="trunk01.local"

export WORKER_2_IP="192.168.22.102"
export WORKER_2_HOST_NAME="trunk02.local"

export WORKER_3_IP="192.168.22.103"
export WORKER_3_HOST_NAME="trunk03.local"

export DOMAIN=$(curl -s ipinfo.io/ip).nip.io
export API_PORT="8443"
export USERNAME="root"
export PASSWORD="put-your-password-here"

# ansible version
export ANSIBLE_VERSION="2.7.0"

# openshift-ansible / openshift
export VERSION="3.11"
export METRICS="True"
export LOGGING="True"
export OPENSHIFT_ORIGIN="https://buildlogs.centos.org/centos/7/paas/x86_64/openshift-origin311"

# docker storage
#export DISK="/dev/sda"