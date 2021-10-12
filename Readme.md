# Fargate with eks

This repo contains code to deploy fargate with a few sample deployments that allow you to configure a dummy app to world.

## Dependencies

* awscli
* eksctl (optional)
* aws-iam-authenticator
* kubectl
* Docker
* Python with pipenv
* Ruby

## Deploy

1. Build both frontend and backend apps and deploy them to Docker hub
1. Update the `common.auto.tfvars` in terraform and run terraform.
1. Once cluster is up and running, genrate kube config and apply the deployments.


## Destroy

1. Terraform should destroy most resources
1. There might be one or two resources that you might need to destory manually as they were created outside of terraform. (Load balancers and security groups)
