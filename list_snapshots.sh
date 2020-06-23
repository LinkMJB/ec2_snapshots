#!/bin/bash

SCRIPTDIR=`dirname $0`
INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
VOLS=`${SCRIPTDIR}/list_volumes.sh`
aws ec2 describe-snapshots --filters Name=volume-id,Values=${VOLS} --output text
