#!/bin/bash

set -e

remove_subs() {
  REGION_ID=$1
  ACCOUNT_ID=$2
  TOPIC_NAME=$3
  
  SUBS_ARN=`aws sns list-subscriptions-by-topic --topic-arn arn:aws:sns:${REGION_ID}:${ACCOUNT_ID}:${TOPIC_NAME} --query 'Subscriptions[*].SubscriptionArn' --output text`
  SUBS_ARRAY=($SUBS_ARN)
  for i in "${SUBS_ARRAY[@]}"
  do
    echo ${i}
    aws sns unsubscribe --subscription-arn ${i}
  done

}

remove_topic() {
  REGION_ID=$1
  ACCOUNT_ID=$2
  TOPIC_NAME=$3

  echo ${TOPIC_NAME}
  aws sns delete-topic --topic-arn arn:aws:sns:${REGION_ID}:${ACCOUNT_ID}:${TOPIC_NAME}
}

remove_queue() {
  REGION_ID=$1
  ACCOUNT_ID=$2
  QUEUE_NAME=$3

  echo ${QUEUE_NAME}
  aws sqs delete-queue --queue-url https://sqs.${REGION_ID}.amazonaws.com/${ACCOUNT_ID}/${QUEUE_NAME}
}

cleanUpChoreography() {
  REGION_ID=$1
  ACCOUNT_ID=$2

  echo 'Performing clean-up of Choreography demo'

  echo 'Removing subscriptions'
  remove_subs ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-orders-success'
  remove_subs ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-orders-fail'
  remove_subs ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-inventory-success'
  remove_subs ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-inventory-fail'
  remove_subs ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-ordersrb-success'
  remove_subs ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-ordersrb-fail'

  echo 'Removing topics'
  remove_topic ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-orders-success'
  remove_topic ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-orders-fail'
  remove_topic ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-inventory-success'
  remove_topic ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-inventory-fail'
  remove_topic ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-ordersrb-success'
  remove_topic ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-ordersrb-fail'

  echo 'Removing queues'
  remove_queue ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-orders-rollback'
  remove_queue ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-inventory-input'
  remove_queue ${REGION_ID} ${ACCOUNT_ID} 'eks-saga-audit'

  echo 'Finished clean-up of Choreography demo'
}

cleanUp() {
  REGION_ID=$1
  ACCOUNT_ID=$2
  DEMO_TYPE=$3

  case "${DEMO_TYPE}" in
    C)
      cleanUpChoreography ${REGION_ID} ${ACCOUNT_ID}
      ;;

    *)
      echo "Invalid value for demo type ${DEMO_TYPE}. Valid value is C(horeography)."
      ;;
  esac
}

if [[ $# -ne 3 ]] ; then
  echo 'USAGE: ./cleanup.sh regionId accountId demoType'
  exit 1
fi

REGION_ID=$1
ACCOUNT_ID=$2
DEMO_TYPE=$3

cleanUp ${REGION_ID} ${ACCOUNT_ID} ${DEMO_TYPE}