#!/bin/bash

REGION="us-west-2"

echo "Create cluster ecs-tutorial, config ecs-tutorial, launch type FARGATE in $REGION"

ecs-cli configure --cluster ecs-tutorial \
                  --default-launch-type FARGATE \
                  --config-name ecs-tutorial \
                  --region $REGION
