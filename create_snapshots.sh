#!/bin/bash
export EC2_ACCESS_KEY=`cat ~/.ec2/access`
export EC2_SECRET_KEY=`cat ~/.ec2/secret`

SNAP_TYPE="$1"
[ "${SNAP_TYPE}" = "" ] && { 
        echo "ERROR: Snapshot frequency must be provided! (hourly|daily|weekly|monthly|yearly)"
	echo "EXAMPLE: $0 daily"
        exit 1
}

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
VOLS=`ec2-describe-volumes -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} | nawk -v myvar=${INSTANCE_ID} '$3 == myvar {print $2}'`
for MYVOL in ${VOLS}; do
	echo "...Creating snapshot of volume ${MYVOL} attached to detected instance ${INSTANCE_ID}" | tee -a ~/ec2_backup.log
	ec2-create-snapshot -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} -d "Automatic ${SNAP_TYPE} backup" ${MYVOL} 2>&1 | tee -a ~/ec2_backup.log 2>&1
done
