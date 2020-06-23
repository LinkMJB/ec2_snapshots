#!/bin/bash

SCRIPTDIR=`dirname $0`
INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`

SNAP_TYPE="$1"
[ "${SNAP_TYPE}" = "" ] && { 
        echo "ERROR: Snapshot frequency must be provided! (hourly|daily|weekly|monthly|yearly)"
	echo "EXAMPLE: $0 daily"
        exit 1
}

VOLS=`${SCRIPTDIR}/list_volumes.sh | tr ',' ' '`
for MYVOL in ${VOLS}; do
	echo "...Creating snapshot of volume ${MYVOL} attached to detected instance ${INSTANCE_ID}" | tee -a ~/ec2_backup.log
	aws ec2 create-snapshot --description "Automatic ${SNAP_TYPE} backup" --volume-id ${MYVOL} 2>&1 | tee -a ~/ec2_backup.log 2>&1
done
