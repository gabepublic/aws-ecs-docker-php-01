#!/bin/bash

REGION="us-west-2"

TASK_ID=""

echo "Enter the TASK_ID?"
read ID_RSA

#            --follow 
ecs-cli logs --task-id $TASK_ID \
             --cluster-config ecs-ec2-tutorial \
             --ecs-profile ecs-tutorial

