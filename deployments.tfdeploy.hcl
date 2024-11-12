# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    regions        = ["eu-central-1"]
    role_arn       = "arn:aws:iam::020954271809:role/stacks-lomar-Learn-Terraform-Stacks-deployments"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }
  }
}

deployment "production" {
  inputs = {
    regions        = ["eu-central-1", "eu-central-2", "eu-north-1"]
    role_arn       = "arn:aws:iam::020954271809:role/stacks-lomar-Learn-Terraform-Stacks-deployments"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }
  }
}

# deployment "test" {
#   inputs = {
#     regions        = ["eu-central-2"]
#     role_arn       = "arn:aws:iam::020954271809:role/stacks-lomar-Learn-Terraform-Stacks-deployments"
#     identity_token = identity_token.aws.jwt
#     default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }
#   }
# }

# deployments.tfdeploy.hcl

orchestrate "auto_approve" "safe_plans_dev" {
  check {
    # Only auto-approve in developement environment if no resources are being removed
    condition = context.plan.changes.remove == 0 && context.plan.deployment == developement
    reason = "Plan has ${context.plan.changes.remove} resources to be removed."
  }
}