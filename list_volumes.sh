#!/bin/bash

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
aws ec2 describe-volumes --output text --filters Name=attachment.instance-id,Values=${INSTANCE_ID} --query "Volumes[*].{ID:VolumeId}" | sort -u | tr '\n' ',' | sed 's/.$/\n/g'
