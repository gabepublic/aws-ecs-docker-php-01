#!/bin/bash

REGION="us-west-2"

ecs-cli compose down --cluster-config ecs-ec2-tutorial \
                     --ecs-profile ecs-tutorial

ecs-cli down --force --cluster-config ecs-ec2-tutorial \
             --ecs-profile ecs-tutorial