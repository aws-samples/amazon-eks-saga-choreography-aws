// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. // SPDX-License-Identifier: CC-BY-SA-4.0

# Introduction

This project will set-up the required AWS artefacts for the `eks-saga-choreography` cluster.

## Usage

> The following links also carry instructions for _both_ installation and clean-up.

1. [SNS and SQS](docs/sns-sqs.md) - to create SNS topic and subscriptions into SQS queues.
2. [IAM](docs/iam.md) - to set-up IAM policies for SNS and RDS.
3. [ECR](docs/ecr.md) - to set-up Amazon ECR repositories.
4. [Images](docs/images.md) - to build and push images to ECR repositories.