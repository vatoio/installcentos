#!/bin/bash

for i in `seq 1 200`;
do
	DIRNAME="vol$i"
	mkdir -p /mnt/data/$DIRNAME 
	chcon -Rt svirt_sandbox_file_t /mnt/data/$DIRNAME
	chmod 777 /mnt/data/$DIRNAME
	
	sed "s/name: vol/name: vol$i/g" pv-template.yaml > oc-vol-temp.yaml
	sed -i "s/path: \/mnt\/data\/vol/path: \/mnt\/data\/vol$i/g" oc-vol-temp.yaml
	oc create -f oc-vol-temp.yaml
	echo "created volume $i"
done
rm oc-vol-temp.yaml