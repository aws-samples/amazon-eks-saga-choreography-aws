// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. // SPDX-License-Identifier: CC-BY-SA-4.0

# Introduction

This page has instructions to set-up IAM policies for SQS, SNS and ELB.

- [Introduction](#introduction)
  - [Usage](#usage)

## Usage

Run this command for **Choreography** pattern.

```bash
git clone ${GIT_URL}/eks-saga-aws
cd eks-saga-aws/scripts
./iam.sh ${REGION_ID} ${ACCOUNT_ID} C
```

To remove IAM set-up, run the following commands.

```bash
git clone ${GIT_URL}/eks-saga-aws
cd eks-saga-aws/scripts
./ciam.sh ${ACCOUNT_ID} C
```
