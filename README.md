# ec2_snapshots
Scripts to work with EC2 snapshots

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
