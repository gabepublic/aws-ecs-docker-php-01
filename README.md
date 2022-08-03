# aws-ecs-docker-php-01

Deploying to AWS ECS a simple docker PHP web app

Source: [AWS - Tutorial: Creating a cluster with a Fargate task using the Amazon ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-fargate.html)

## Prerequisite

- AWS account
- AWS CLI installed & configured
- AWS ECS CLI installed; will be configured below
- Docker hub image: `amazon/amazon-ecs-sample`
- Linux environment

### AWS account

Go to [Amazon AWS](https://aws.amazon.com/) to create an account.

### AWS CLI installed & Configured

- Install AWS CLI - see [Getting started with the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

- Configure AWS CLI

- We assume that the AWS CLI has been configured as follow.

- The `default` profile has been created and stored in the `~/.aws/config` file
  as follow:
```
[default]
region=us-west-2
```

- The `default` credentials has been created and stored in the 
  `~/.aws/credential` file as follow:
```
[default]
aws_access_key_id = <replace_with_actual_id>
aws_secret_access_key = <replace_with_actual_secret>
```

### AWS ECS CLI installed & configured

- [Installing the Amazon ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html)

- [Configuring the Amazon ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_Configuration.html)
  We assume that the Amazon ECS CLI profile has been created with profile name
  of `ecs-tutorial`, and stored in the `~/.ecs/credentials` file, as follow:
```
version: v1
[...]
ecs_profiles:
  ecs-tutorial:
    aws_access_key_id: <replace_with_actual_id>
    aws_secret_access_key: <replace_with_actual_secret>
```

- We will configure the ECS CLI specifically for deploying this demo in this
  repo


## Setup

The following setup tasks can be perfomed manually or by running the scripts
included with this repo.

- [Optional] to run the scripts, you need to make them executable first
```
$ chmod +x *.sh
```

- To do it manually, copy the command inside the script file

- Please review the scripts or the command before running it; some parameters
  may need to bee adjusted to meet your preferred environment 

- (Included with this repo) Create a file named `task-execution-assume-role.json`
  that will be needed below.

- Create the task execution IAM role:
  - Create the role using `01_create_task_execution_role.sh`
```
$ ./01_create_task_execution_role.sh
{
    "Role": {
        "Path": "/",
        "RoleName": "ecsTaskExecutionRole",
        "RoleId": "AROAVCVML3GI6HP63TY5V",
        "Arn": "arn:aws:iam::349327579537:role/ecsTaskExecutionRole",
        "CreateDate": "2022-08-02T18:30:36+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "",
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ecs-tasks.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
}
```

  - Attach the task execution role policy using `02_create_task_execution_role_policy.sh`
```
$ ./02_create_task_execution_role_policy.sh
```

- Configure the Amazon ECS CLI specifically for deploying this demo:
  - As indicated above, we assume that the ECS CLI has been installed; and the 
    Amazon ECS profile, `ecs-tutorial`, has been configured. 
  - the Amazon ECS CLI requires credentials in order to make API requests on 
    behalf of the user. It can pull credentials from environment variables, 
    an AWS profile, or an Amazon ECS profile. In this case, we will use the
    Amazon ECS `ecs-tutorial` profile
  - Create a cluster configuration, which defines the AWS region to use, 
    resource creation prefixes, and the cluster name to use with the Amazon ECS 
    CLI; using the `03_create_aws_ecs_cluster_config.sh`:
```
$ ./03_create_aws_ecs_cluster_cconfig.sh
INFO[0000] Saved ECS CLI cluster configuration ecs-tutorial.
```
  - Verify the local `~/.ecs/config` file contains the following:
```
version: v1
[...]
clusters:
  ecs-tutorial:
    cluster: ecs-tutorial
    region: us-west-2
    default_launch_type: FARGATE
[...]
```

- Create a AWS cloud Cluster and Configure the Security Group
  - Create an Amazon ECS cluster with the `ecs-cli up` command using the script
    `04_create_aws_ecs_cluster_create.sh`. Because we specified to use the 
    `--default-launch-type FARGATE` in the ECS cluster configuration (see above),
    this command creates an empty cluster and a VPC configured with two public 
    subnets. This command may take a few minutes to complete as your resources 
    are created.
```
$ ./04_create_aws_ecs_cluster_create.sh
Create aws cloud cluster based on cli config and profile...
INFO[0000] Created cluster                               cluster=ecs-tutorial region=us-west-2
INFO[0001] Waiting for your cluster resources to be created...
INFO[0001] Cloudformation stack status                   stackStatus=CREATE_IN_PROGRESS
VPC created: vpc-0bcd5be4fd15bd3e5
Subnet created: subnet-0d90b30b798f6abc4
Subnet created: subnet-02b8496d7e53a2717
Cluster creation succeeded.
```
  - **CAPTURE** the `VPC ID` and `subnet IDs` that are created, as we will need them
    in the following steps. Also, check the AWS console that the cluster has been
    created; go to "Amazon Elastic Container Service > Cluster"
    
  - (Need to update the script `VPC_ID` from above) using the AWS EC2 CLI, 
    retrieve the default security `GroupId` for the VPC. Update then script
    to use the VPC ID from the output above.
```
$ ./05_retrieve_vpc_secinfo.sh
{
    "SecurityGroups": [
        {
            "Description": "default VPC security group",
            "GroupName": "default",
            "IpPermissions": [
                {
                    "IpProtocol": "-1",
                    "IpRanges": [],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "UserIdGroupPairs": [
                        {
                            "GroupId": "sg-099b0b055f0c738c5",
                            "UserId": "349327579537"
                        }
                    ]
                }
            ],
            "OwnerId": "349327579537",
            "GroupId": "sg-099b0b055f0c738c5",
            "IpPermissionsEgress": [
                {
                    "IpProtocol": "-1",
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "UserIdGroupPairs": []
                }
            ],
            "VpcId": "vpc-0bcd5be4fd15bd3e5"
        }
    ]
}
```
  - (Need to update the script `GROUP_ID`) - add a security group rule to 
    allow inbound access on port `80` using AWS EC2 CLI, by running the script:
```
$ ./06_create_aws_ecs_cluster_create_secrule.sh
add a security group rule to allow inbound access on port 80
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0f0c0fdef9ea5b61c",
            "GroupId": "sg-099b0b055f0c738c5",
            "GroupOwnerId": "349327579537",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}
```

- (Included with this repo) Create a docker Compose File (`docker-compose.yml`) 
  and add parameters specific to Amazon ECS.
  - NOTE: the Amazon ECS CLI supports Docker compose file syntax versions 1, 2,
    and 3. The version specified in the compose file must be the string "1", 
    "1.0", "2", "2.0", "3", or "3.0". Docker Compose minor versions are not 
    supported.
  - Additional configurations for the container logs to go to the CloudWatch 
    log group, `ecs-tutorial`, created earlier. This is the recommended 
    best practice for Fargate tasks.
    
- (Included with this repo but need to update the subnets & security group) - 
  in addition to the Docker compose information, there are some parameters 
  specific to Amazon ECS that you must specify for the service. 
  Using the VPC, subnet, and security group IDs from the previous step, 
  create a file named `ecs-params.yml`.   

- Deploy to the Cluster, `ecs-tutorial`, the docker configurations defined
  in the compose file, `docker-compose.yml`, and `ecs-params.yml`, using the 
  `07_create_aws_ecs_cluster_deploy.sh` script.
```
$ ./07_create_aws_ecs_cluster_deploy.sh
INFO[0000] Using ECS task definition                     TaskDefinition="ecs-tutorial:2"
INFO[0000] Created Log Group ecs-tutorial in us-west-2
INFO[0000] Auto-enabling ECS Managed Tags
INFO[0011] (service ecs-tutorial) has started 1 tasks: (task f4ce14268f8e4cdabd254e210eec6c52).  timestamp="2022-08-02 23:21:02 +0000 UTC"
INFO[0037] Service status                                desiredCount=1 runningCount=1 serviceName=ecs-tutorial
INFO[0037] ECS Service has reached a stable state        desiredCount=1 runningCount=1 serviceName=ecs-tutorial
INFO[0037] Created an ECS service                        service=ecs-tutorial taskDefinition="ecs-tutorial:2"
```

- View the Running Containers on a Cluster
```
$ ./08_view_running_containers.sh
Name                                               State    Ports                    TaskDefinition  Health
ecs-tutorial/f4ce14268f8e4cdabd254e210eec6c52/web  RUNNING  34.208.74.12:80->80/tcp  ecs-tutorial:2  UNKNOWN
```

- Use web browser to see the app at `http://34.208.74.12:80/`

- View the Container Logs; the script needs to be updated with the `TASK_ID`
  value for the container, shwon above. NOTE: the logs is empty.
```
$ ./09_view_container_logs.sh
# --follow option continuously poll for logs
$ ecs-cli logs --task-id f4ce14268f8e4cdabd254e210eec6c52 --follow --cluster-config ecs-tutorial --ecs-profile ecs-tutorial
```

- Scale the Tasks (number of containers) on the Cluster
```
$ ./10_scale_up_numberof_containers.sh
INFO[0000] Updated ECS service successfully              desiredCount=2 force-deployment=false service=ecs-tutorial
INFO[0000] Service status                                desiredCount=2 runningCount=1 serviceName=ecs-tutorial
INFO[0010] (service ecs-tutorial) has started 1 tasks: (task 6abb07aaadc34ecb92a90a8041c1b6e1).  timestamp="2022-08-02 23:44:58 +0000 UTC"
INFO[0031] Service status                                desiredCount=2 runningCount=2 serviceName=ecs-tutorial
INFO[0031] (service ecs-tutorial) has reached a steady state.  timestamp="2022-08-02 23:45:15 +0000 UTC"
INFO[0031] ECS Service has reached a stable state        desiredCount=2 runningCount=2 serviceName=ecs-tutorial
```
  - Verify the number of clusters
```
$ ./08_view_running_containers.sh
Name                                               State    Ports                      TaskDefinition  Health
ecs-tutorial/6abb07aaadc34ecb92a90a8041c1b6e1/web  RUNNING  34.215.183.241:80->80/tcp  ecs-tutorial:2  UNKNOWN
ecs-tutorial/f4ce14268f8e4cdabd254e210eec6c52/web  RUNNING  34.208.74.12:80->80/tcp    ecs-tutorial:2  UNKNOWN
```

- View the application from the URL:
  - `http://34.208.74.12:80/`
  - `http://34.215.183.241:80/`


## CLEANUP

- Delete the service so that it stops the existing containers and does not try 
  to run any more tasks. Then take down your cluster, which cleans up the 
  resources that you created earlier with ecs-cli up. Both tasks have been
  included in the `11_cleanup_aws_ecs_cluster.sh` script:
```
$ ./11_cleanup_aws_ecs_cluster.sh
INFO[0000] Deleted ECS service                           service=ecs-tutorial
INFO[0000] Service status                                desiredCount=0 runningCount=2 serviceName=ecs-tutorial
INFO[0010] Service status                                desiredCount=0 runningCount=0 serviceName=ecs-tutorial
INFO[0010] (service ecs-tutorial) has stopped 2 running tasks: (task 6abb07aaadc34ecb92a90a8041c1b6e1) (task f4ce14268f8e4cdabd254e210eec6c52).  timestamp="2022-08-02 23:48:48 +0000 UTC"
INFO[0010] ECS Service has reached a stable state        desiredCount=0 runningCount=0 serviceName=ecs-tutorial
INFO[0000] Waiting for your cluster resources to be deleted...
INFO[0001] Cloudformation stack status                   stackStatus=DELETE_IN_PROGRESS
INFO[0061] Cloudformation stack status                   stackStatus=DELETE_IN_PROGRESS
INFO[0092] Deleted cluster                               cluster=ecs-tutorial
```

- Delete task definitions, `ecs-tutorial`, from the AWS console; go to
  "Amazon Elastic Container Service > Task Definitions" page.
  - Click the task definitions `ecs-tutorial`
  - On the `ecs-tutorial` task definitions page, select the `ecs-tutorial`
    Task definition: revision, then "Deregister"

- Delete the CloudWatch log group, `ecs-tutorial`, from the AWS Console, go to
  "CloudWatch > Log groups"

- Delete the role name `ecsTaskExecutionRole` (if no longer needed);
  use the "AWS console > IAM > Access Management > Roles"
  
- Delete the AWS ECS profile `ecs-tutorial` (if no longer needed) from the local
  `~/.ecs/config` file:
```
version: v1
[...]
clusters:
  ecs-tutorial:
    cluster: ecs-tutorial
    region: us-west-2
    default_launch_type: FARGATE
[...]
```

## References

- REF-1: [AWS - Tutorial: Creating a cluster with a Fargate task using the Amazon ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-fargate.html)