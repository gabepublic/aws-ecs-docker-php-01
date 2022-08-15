#!/bin/bash

REGION="us-west-2"

ecs-cli compose --project-name ecs-tutorial \
        service ps --cluster-config ecs-tutorial \
                   --ecs-profile ecs-tutorial