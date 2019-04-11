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

# openshift-ansible / openshift
export VERSION="4.0"
export METRICS="True"
export LOGGING="True"

# docker storage
#export DISK="/dev/sda"