#!/bin/bash

set -e 

c_policy() {
  REGION_ID=$1
  ACCOUNT_ID=$2

  JSON_DIR=../json
  cd ${JSON_DIR}
  
  sed -e 's/regionId/'"${REGION_ID}"'/g' -e 's/accountId/'"${ACCOUNT_ID}"'/g' ${JSON_DIR}/eks-saga-sqs-chore-policy.json > ${JSON_DIR}/eks-saga-sqs-chore-policy.json.policy
  POLICY_ARN=`aws iam create-policy --policy-name eks-saga-sqs-chore-policy --policy-document file://eks-saga-sqs-chore-policy.json.policy --query 'Policy.Arn' --output text`
  echo "SQS Policy ARN: ${POLICY_ARN}"

  sed -e 's/regionId/'"${REGION_ID}"'/g' -e 's/accountId/'"${ACCOUNT_ID}"'/g' ${JSON_DIR}/eks-saga-sns-chore-policy.json > ${JSON_DIR}/eks-saga-sns-chore-policy.json.policy
  POLICY_ARN=`aws iam create-policy --policy-name eks-saga-sns-chore-policy --policy-document file://eks-saga-sns-chore-policy.json.policy --query 'Policy.Arn' --output text`
  echo "SNS Policy ARN: ${POLICY_ARN}"

  rm ${JSON_DIR}/eks-saga-sqs-chore-policy.json.policy
}

elb_policy() {
  REGION_ID=$1
  ACCOUNT_ID=$2

  JSON_DIR=../json
  cd ${JSON_DIR}

  POLICY_ARN=`aws iam create-policy --policy-name eks-saga-elb-policy --policy-document file://eks-saga-elb-policy.json --query 'Policy.Arn' --output text`
  echo "ELB Policy ARN: ${POLICY_ARN}"
}

if [[ $# -ne 3 ]] ; then
  echo 'USAGE: ./iam.sh regionId accountId demoType'
  exit 1
fi

REGION_ID=$1
ACCOUNT_ID=$2
DEMO_TYPE=$3

case "${DEMO_TYPE}" in
  C)
    c_policy ${REGION_ID} ${ACCOUNT_ID}
    ;;

  *)
    echo "Invalid value for demo type ${DEMO_TYPE}. Valid values are C(horeography)."
    ;;
esac

elb_policy