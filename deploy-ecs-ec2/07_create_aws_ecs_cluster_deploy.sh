#!/bin/bash

REGION="us-west-2"

echo "deploy the cluster "

ecs-cli compose up --create-log-groups \
                   --cluster-config ecs-ec2-tutorial \
                   --ecs-profile ecs-tutorial