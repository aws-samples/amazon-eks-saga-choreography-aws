#!/bin/bash

set -e

r_policy() {
  ACCOUNT_ID=$1

  echo 'Removing AWS SQS policy'
  aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/eks-saga-sqs-orche-policy
  echo 'Removing AWS SNS policy'
  aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/eks-saga-sns-orche-policy
}

if [[ $# -ne 2 ]] ; then
  echo 'USAGE: ./ciam.sh accountId demoType'
  exit 1
fi

ACCOUNT_ID=$1
DEMO_TYPE=$2

case "${DEMO_TYPE}" in
  C)
    r_policy ${ACCOUNT_ID}
    ;;

  *)
    echo "Invalid value for demo type ${DEMO_TYPE}. Valid values are C(horeography)."
    ;;
esac
