#!/bin/bash

REGION="us-west-2"

ecs-cli compose --project-name ecs-tutorial \
        service down --cluster-config ecs-tutorial \
                     --ecs-profile ecs-tutorial

ecs-cli down --force --cluster-config ecs-tutorial \
             --ecs-profile ecs-tutorial