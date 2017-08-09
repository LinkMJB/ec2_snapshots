#!/bin/bash
export EC2_ACCESS_KEY=`cat ~/.ec2/access`
export EC2_SECRET_KEY=`cat ~/.ec2/secret`

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
VOLS=`ec2-describe-volumes -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} | nawk -v myvar=${INSTANCE_ID} '$3 == myvar {print $2}'`
MVOLS=`echo ${VOLS} | tr ' ' '|'`
ec2-describe-snapshots -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} | egrep "${MVOLS}" | sort -k 5 -r
