#!/bin/bash

REGION="us-west-2"

TASK_ID="f4ce14268f8e4cdabd254e210eec6c52"

#            --follow 
ecs-cli logs --task-id $TASK_ID \
             --cluster-config ecs-tutorial \
             --ecs-profile ecs-tutorial

