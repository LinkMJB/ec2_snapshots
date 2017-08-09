#!/bin/bash
export EC2_ACCESS_KEY=`cat ~/.ec2/access`
export EC2_SECRET_KEY=`cat ~/.ec2/secret`

SNAP_TYPE="$1"
[ "${SNAP_TYPE}" = "" ] && {
	echo "ERROR: Snapshot frequency must be provided! (hourly|daily|weekly|monthly|yearly)"
        echo "EXAMPLE: $0 daily 7"
	exit 1
}

KEEP_NUM="$2"
[[ "${KEEP_NUM}" == [0-9] ]] || {
        echo "ERROR: Snapshot retention must be provided! (24|7|4|12|3)"
        echo "EXAMPLE: $0 daily 7"
        exit 1
}

INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
VOLS=`ec2-describe-volumes -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} | nawk -v myvar=${INSTANCE_ID} '$3 == myvar {print $2}'`
for MYVOL in ${VOLS}; do
	IFS="
"
	for MYLINE in `ec2-describe-snapshots -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} | nawk -v myvar=${MYVOL} '$3 == myvar {print}' | sort -k 5 -r | grep "Automatic ${SNAP_TYPE} backup" | sed 1,${KEEP_NUM}d`; do
		MYSNAP=`echo ${MYLINE} | awk '{print $2}'`
		echo "...Deleting old ${SNAP_TYPE} snapshot ${MYSNAP} attached to ${MYVOL}" | tee -a ~/ec2_backup.log
		ec2-delete-snapshot -O ${EC2_ACCESS_KEY} -W ${EC2_SECRET_KEY} ${MYSNAP} 2>&1 | tee -a ~/ec2_backup.log 2>&1
	done
done
