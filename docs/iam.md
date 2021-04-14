// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. // SPDX-License-Identifier: CC-BY-SA-4.0

# Introduction

This page has instructions to set-up IAM policies for SQS, SNS and ELB.

- [Introduction](#introduction)
  - [Usage](#usage)

## Usage

```bash
git clone ${GIT_URL}/amazon-eks-saga-choreography-aws
cd amazon-eks-saga-choreography-aws/scripts
./iam.sh ${REGION_ID} ${ACCOUNT_ID} O
```

To remove IAM set-up, run the following commands.

```bash
git clone ${GIT_URL}/amazon-eks-saga-choreography-aws
cd amazon-eks-saga-choreography-aws/scripts
./ciam.sh ${ACCOUNT_ID} O
```
