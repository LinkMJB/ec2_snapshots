# ec2_snapshots
Scripts to work with EC2 snapshots

## Prerequisites

* Install AWS CLI v2: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
```
aws configure
```

## Permissions

Here are the bare minimum permissions the user associated with the access key creds referenced by the scripts will need:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:DescribeSnapshots"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

Then just setup your crontab to run the create and cleanup actions on the schedules you desire:

```
02 3 * * * /home/ubuntu/scripts/ec2/create_snapshots.sh daily
32 3 * * * /home/ubuntu/scripts/ec2/cleanup_snapshots.sh daily 7
02 4 * * 0 /home/ubuntu/scripts/ec2/create_snapshots.sh weekly
32 4 * * 0 /home/ubuntu/scripts/ec2/cleanup_snapshots.sh weekly 4
02 5 1 * * /home/ubuntu/scripts/ec2/create_snapshots.sh monthly
32 5 1 * * /home/ubuntu/scripts/ec2/cleanup_snapshots.sh monthly 3
```
