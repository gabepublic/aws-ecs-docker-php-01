#!/bin/bash

REGION="us-west-2"

echo "Create aws cloud cluster based on cli config and profile..."

ecs-cli up --cluster-config ecs-tutorial \
           --ecs-profile ecs-tutorial