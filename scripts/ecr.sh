#!/bin/bash

set -e

e_create() {
  REPO_NAME=$1
  REPO_ARN=`aws ecr create-repository --repository-name eks-saga/${REPO_NAME} --image-scanning-configuration scanOnPush=true --tags Key=project,Value=eks-saga Key=projectType,Value=demo --query 'repository.repositoryArn' --output text`
  echo "${REPO_NAME} - ${REPO_ARN}"
}

e_delete() {
  REPO_NAME=$1
  aws ecr delete-repository --repository-name eks-saga/${REPO_NAME} --force
}

e_setup() {
  e_create orders
  e_create ordersrb
  e_create inventory
  e_create audit
  e_create trail
}

e_remove() {
  e_delete orders
  e_delete ordersrb
  e_delete inventory
  e_delete audit
  e_delete trail
}

# Main
if [[ $# -ne 1 ]] ; then
  echo 'USAGE: ./ecr.sh actionType'
  exit 1
fi

ACTION_TYPE=$1
case "${ACTION_TYPE}" in
    C)
      e_setup
      ;;

    D)
      e_remove
      ;;

    *)
      echo "Invalid value for action type ${ACTION_TYPE}. Valid values are C(reate) or D(elete)."
      ;;
esac