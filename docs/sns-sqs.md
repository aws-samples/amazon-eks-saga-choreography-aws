// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. // SPDX-License-Identifier: CC-BY-SA-4.0

# Introduction

This page has instructions to set-up AWS SNS topics and subscriptions into AWS SQS.

- [Introduction](#introduction)
  - [Installation](#installation)
  - [Clean-up](#clean-up)

## Installation

Run this command to create topics, subscriptions queue for **Choreography** pattern.

```bash
git clone ${GIT_URL}/eks-saga-aws
cd eks-saga-aws/scripts
./choreography.sh ${REGION_ID} ${ACCOUNT_ID}
```

## Clean-up

To clean up after the **Choreography** demo, run this command.

```bash
git clone ${GIT_URL}/eks-saga-aws
cd eks-saga-aws/scripts
./cleanup.sh ${REGION_ID} ${ACCOUNT_ID} C
```