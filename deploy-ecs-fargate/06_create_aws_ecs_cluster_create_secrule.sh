#!/bin/bash

REGION="us-west-2"

SECGROUP_ID="sg-099b0b055f0c738c5"

echo "add a security group rule to allow inbound access on port 80"

aws ec2 authorize-security-group-ingress --group-id $SECGROUP_ID \
        --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
