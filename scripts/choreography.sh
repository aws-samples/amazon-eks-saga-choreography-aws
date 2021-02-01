#!/bin/bash

set -e

# Create SNS topic
t_setup() {
  TNAME=$1

  TOPIC_ARN=`aws sns create-topic --name ${TNAME} --query 'TopicArn' --output text`
  echo "Topic Name ${TNAME} Topic ARN ${TOPIC_ARN}"
}

# Create SQS queue
q_setup() {
  SQS_ACCESS_POLICY_TMPL=../json/eks-saga-sqs-access-policy.json
  POLICY_DOC=../json/policy-doc.json
  SQS_ACCESS_POLICY=../json/sqs-access-policy.json

  QNAME=$1
  REGION_ID=$2
  ACCOUNT_ID=$3

  Q_URL=`aws sqs create-queue --queue-name ${QNAME} --query 'QueueUrl' --output text`

  jq --arg REGION ${REGION_ID} --arg ACCOUNTID ${ACCOUNT_ID} --arg QNAME ${QNAME} 'walk( 
    if type == "string" 
    then gsub("\\$(?<name>\\w+)"; $ARGS.named[.name]) 
    else . end 
  )' ${SQS_ACCESS_POLICY_TMPL} > ${POLICY_DOC}
  P=`tr -d '\n' < ${POLICY_DOC}`
  POLICY_DOC_STR=$(echo ${P//\"/\\\"})

  echo '{"Policy": "'${POLICY_DOC_STR}'"}' > ${SQS_ACCESS_POLICY}
  aws sqs set-queue-attributes --queue-url ${Q_URL} --attributes file://${SQS_ACCESS_POLICY}
  aws sqs set-queue-attributes --queue-url ${Q_URL} --attributes MessageRetentionPeriod=300,ReceiveMessageWaitTimeSeconds=2

  rm ${POLICY_DOC} ${SQS_ACCESS_POLICY}
  echo "Queue name ${QNAME} Queue URL ${Q_URL}"
}

# Create SNS subscriptions with provided SNS topic and SQS queue names
s_setup() {
  QNAME=$1
  TNAME=$2
  REGION_ID=$3
  ACCOUNT_ID=$4

  QUEUE_ARN=arn:aws:sqs:${REGION_ID}:${ACCOUNT_ID}:${QNAME}
  TOPIC_ARN=arn:aws:sns:${REGION_ID}:${ACCOUNT_ID}:${TNAME}
  SUBS_ARN=`aws sns subscribe --topic-arn ${TOPIC_ARN} --protocol sqs --notification-endpoint ${QUEUE_ARN} --attributes RawMessageDelivery=true --query 'SubscriptionArn' --output text`
  echo "Topic name ${TNAME} Queue name ${QNAME} Subscription ARN ${SUBS_ARN}"
}

# Create all topics for Choreography demo
t_create() {
  echo 'Creating topics for Choreography'

  echo 'Setting up topics for Orders microservice'
  t_setup 'eks-saga-orders-success'
  t_setup 'eks-saga-orders-fail'

  echo 'Setting up topics for Orders rollback microservice'
  t_setup 'eks-saga-ordersrb-success'
  t_setup 'eks-saga-ordersrb-fail'

  echo 'Setting up topics for Inventory microservice'
  t_setup 'eks-saga-inventory-success'
  t_setup 'eks-saga-inventory-fail'
}

# Create all queues for Choreography demo
q_create() {
  REGION_ID=$1
  ACCOUNT_ID=$2

  echo 'Creating queues for Choreography'

  echo 'Setting up queues for Orders microservice'
  q_setup 'eks-saga-orders-rollback' ${REGION_ID} ${ACCOUNT_ID}

  echo 'Setting up queues for Inventory microservice'
  q_setup 'eks-saga-inventory-input' ${REGION_ID} ${ACCOUNT_ID}

  echo 'Setting up queues for Audit microservice'
  q_setup 'eks-saga-audit' ${REGION_ID} ${ACCOUNT_ID}
}

# Create subscriptions using topics and queues created above for Choreography demo
s_create() {
  REGION_ID=$1
  ACCOUNT_ID=$2

  echo 'Setting up topic subscriptions for Choreography'

  echo 'Setting up subscriptions for Orders microservice'
  s_setup 'eks-saga-orders-rollback' 'eks-saga-inventory-fail' ${REGION_ID} ${ACCOUNT_ID}

  echo 'Setting up subscriptions for Inventory microservice'
  s_setup 'eks-saga-inventory-input' 'eks-saga-orders-success' ${REGION_ID} ${ACCOUNT_ID}

  echo 'Setting up subscriptions for Audit microservice'
  s_setup 'eks-saga-audit' 'eks-saga-orders-success' ${REGION_ID} ${ACCOUNT_ID}
  s_setup 'eks-saga-audit' 'eks-saga-orders-fail' ${REGION_ID} ${ACCOUNT_ID}
  s_setup 'eks-saga-audit' 'eks-saga-ordersrb-success' ${REGION_ID} ${ACCOUNT_ID}
  s_setup 'eks-saga-audit' 'eks-saga-ordersrb-fail' ${REGION_ID} ${ACCOUNT_ID}
  s_setup 'eks-saga-audit' 'eks-saga-inventory-success' ${REGION_ID} ${ACCOUNT_ID}
  s_setup 'eks-saga-audit' 'eks-saga-inventory-fail' ${REGION_ID} ${ACCOUNT_ID}
}

# Main
if [[ $# -ne 2 ]] ; then
  echo 'USAGE: ./choreography.sh regionId accountId'
  exit 1
fi

REGION_ID=$1
ACCOUNT_ID=$2

t_create
q_create ${REGION_ID} ${ACCOUNT_ID}
s_create ${REGION_ID} ${ACCOUNT_ID}
