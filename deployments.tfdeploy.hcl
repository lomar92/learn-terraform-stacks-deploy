# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    regions        = ["us-east-1"]
    role_arn       = "arn:aws:iam::020954271809:role/stacks-lomar-Learn-Terraform-Stacks-deployments"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }
  }
}

deployment "production" {
  inputs = {
    regions     = ["us-east-1", "us-west-1"]
    role_arn       = "arn:aws:iam::020954271809:role/stacks-lomar-Learn-Terraform-Stacks-deployments"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }
  }
}

deployment "test" {
  inputs = {
    regions        = ["us-east-1"]
    role_arn       = "arn:aws:iam::020954271809:role/stacks-lomar-Learn-Terraform-Stacks-deployments"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }
  }
}

# deployments.tfdeploy.hcl

orchestrate "auto_approve" "safe_plans" {
    # Check that no resources are removed
    check {
        condition = context.plan.changes.remove == 0
        reason = "Plan is destroying ${context.plan.changes.remove} resources."
    }

    # Only allow auto-approve for non-production environments
    check {
        condition = context.plan.deployment != deployment.production
        reason = "Production plans are not eligible for auto_approve."
    }
}
