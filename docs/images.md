// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. // SPDX-License-Identifier: CC-BY-SA-4.0

# Introduction

This page describes the building and pushing of images to Amazon ECR repositories.

## Usage

Run this command to build and push **Choreography** pattern related images to Amazon ECR repositories.

```bash
git clone ${GIT_URL}/amazon-eks-saga-choreography-aws
cd amazon-eks-saga-choreography-aws/scripts
./images.sh ${REGION_ID} ${ACCOUNT_ID} ${GIT_URL} O
```
