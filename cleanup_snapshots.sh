#!/bin/bash

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
SCRIPTDIR=`dirname $0`
VOLS=`${SCRIPTDIR}/list_volumes.sh | tr ',' ' '`
for MYVOL in ${VOLS}; do
	for MYSNAP in `aws ec2 describe-snapshots --output text --filters "Name=volume-id,Values=${MYVOL}" "Name=description,Values='Automatic ${SNAP_TYPE} backup'" "Name=status,Values=completed" --query "Snapshots[*].{ID:SnapshotId}" | sed 1,${KEEP_NUM}d`; do
		echo "...Deleting old ${SNAP_TYPE} snapshot ${MYSNAP} attached to ${MYVOL}" | tee -a ~/ec2_backup.log
		aws ec2 delete-snapshot --snapshot-id ${MYSNAP} 2>&1 | tee -a ~/ec2_backup.log 2>&1
	done
done
