#!/bin/bash

REGION="us-west-2"

VPC_ID="vpc-0bcd5be4fd15bd3e5"

echo "retrieve VPC default security info:"

aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID \
        --region $REGION
