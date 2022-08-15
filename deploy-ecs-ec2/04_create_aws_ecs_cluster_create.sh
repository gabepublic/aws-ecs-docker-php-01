#!/bin/bash

REGION="us-west-2"

ID_RSA=""

echo "Enter the SSH RSA key-pair?"
read ID_RSA

echo "Create aws cloud cluster based on cli config and profile..."

ecs-cli up --keypair $ID_RSA --capability-iam --size 1 \
           --instance-type t2.micro \
           --cluster-config ecs-ec2-tutorial \
           --ecs-profile ecs-tutorial