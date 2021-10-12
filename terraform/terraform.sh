#!/bin/bash
if [[ "$2" != "-i" ]]; then
  export KUBE_CONFIG_PATH="~/.kube/config"
fi

AWS_ACCESS_SECRET=$(grep aws_secret_key secrets.tfvars | grep -o '".*"' | sed 's/"//g')

if [[ "$1" == "init" ]]; then
  terraform get -update
  terraform init -backend-config="secret_key=$AWS_ACCESS_SECRET"
elif [[ "$1" == "apply" ]]; then
  terraform apply -var="aws_secret_key=$AWS_ACCESS_SECRET"
else
  terraform "$1" -var="aws_secret_key=$AWS_ACCESS_SECRET"
fi
