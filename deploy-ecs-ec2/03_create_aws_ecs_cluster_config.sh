#!/bin/bash

REGION="us-west-2"

echo "Create a cluster ecs-ec2-tutorial, config ecs-ec2-tutorial, launch type EC2 in $REGION"

ecs-cli configure --cluster ecs-ec2-tutorial \
                  --default-launch-type EC2 \
                  --config-name ecs-ec2-tutorial \
                  --region $REGION
