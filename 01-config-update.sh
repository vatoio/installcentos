#!/bin/bash

# First you should create ssh key for each node , then ssh-copy-id all node together
export IP_MASTER="192.168.22.100"
export IP_WORKER_1="192.168.22.101"
export IP_WORKER_2="192.168.22.102"
export IP_WORKER_3="192.168.22.103"

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