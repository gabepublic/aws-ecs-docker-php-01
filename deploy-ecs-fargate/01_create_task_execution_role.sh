#!/bin/bash

REGION="us-west-2"

echo "Creating ecsTaskExecutionRole in $REGION"

aws iam --region $REGION \
    create-role --role-name ecsTaskExecutionRole \
                --assume-role-policy-document file://task-execution-assume-role.json