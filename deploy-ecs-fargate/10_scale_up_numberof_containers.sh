#!/bin/bash

REGION="us-west-2"

ecs-cli compose --project-name ecs-tutorial \
        service scale 2 --cluster-config ecs-tutorial \
                        --ecs-profile ecs-tutorial
