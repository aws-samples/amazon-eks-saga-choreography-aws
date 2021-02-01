#!/bin/bash

set -e

e_build() {
  REGION_ID=$1
  ACCOUNT_ID=$2
  GIT_URL=$3
  BUILD_DIR=$4
  REPO_NAME=$5
  IMAGE_NAME=$6

  SCRIPT_DIR=${PWD}

  aws ecr get-login-password --region ${REGION_ID} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION_ID}.amazonaws.com
  IMAGE_URI=${ACCOUNT_ID}.dkr.ecr.${REGION_ID}.amazonaws.com/eks-saga/${IMAGE_NAME}

  git clone ${GIT_URL}/${REPO_NAME} ${BUILD_DIR}/${REPO_NAME}
  cd ${BUILD_DIR}/${REPO_NAME}/src
  docker build -t ${IMAGE_URI}:0.0.0 . && docker push ${IMAGE_URI}:0.0.0

  cd ${SCRIPT_DIR}
}

e_images() {
  REGION_ID=$1
  ACCOUNT_ID=$2
  GIT_URL=$3

  BUILD_DIR=../build
  mkdir ${BUILD_DIR}  

  e_build ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL} ${BUILD_DIR} 'eks-saga-orders' 'orders'
  e_build ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL} ${BUILD_DIR} 'eks-saga-orders-rb' 'ordersrb'
  e_build ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL} ${BUILD_DIR} 'eks-saga-inventory' 'inventory'
  e_build ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL} ${BUILD_DIR} 'eks-saga-audit' 'audit'
  e_build ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL} ${BUILD_DIR} 'eks-saga-trail' 'trail'

  rm -rf ${BUILD_DIR}
}

# Main
if [[ $# -ne 4 ]] ; then
  echo 'USAGE: ./images.sh regionId accountId gitUrl demoType'
  exit 1
fi

REGION_ID=$1
ACCOUNT_ID=$2
GIT_URL=$3
DEMO_TYPE=$4

if (! docker stats --no-stream ); then
  exit 1
fi

case "${DEMO_TYPE}" in
  C)
    e_images ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL}
    ;;

  *)
    echo "Invalid value for demo type ${DEMO_TYPE}. Valid values are C(horeography)."
    ;;
esac
