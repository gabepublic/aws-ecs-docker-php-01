#!/bin/bash

REGION="us-west-2"

ecs-cli compose scale 2 --cluster-config ecs-ec2-tutorial \
                        --ecs-profile ecs-tutorial
