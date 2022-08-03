#!/bin/bash

REGION="us-west-2"

echo "Add to ecsTaskExecutionRole, policy AmazonECSTaskExecutionRolePolicy, in $REGION"

aws iam --region $REGION \
    attach-role-policy --role-name ecsTaskExecutionRole \
                       --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
                       