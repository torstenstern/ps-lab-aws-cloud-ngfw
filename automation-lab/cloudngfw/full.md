terraform {
  required_providers {
    cloudngfwaws = {
      source = "PaloAltoNetworks/cloudngfwaws"
      version = "1.0.8"
    }
  }
}

provider "cloudngfwaws" {
  host    = "api.us-east-1.aws.cloudngfw.paloaltonetworks.com"
  region  = "us-east-1"
  logging  = ["login", "get", "post", "put", "delete", "path", "send", "receive"]
  lra_arn = "arn:aws:iam:" ## Replace with the ARN of the IAM role you created
}

resource "cloudngfwaws_rulestack" "example" {
  name        = "terraform-rulestack"
  scope       = "Local"
  account_id  = "527******" ## Replace with your Qwiklabs account ID
  description = "Made by Terraform"
  profile_config {
    anti_spyware = "BestPractice"
  }
}

resource "cloudngfwaws_prefix_list" "attack-vpc" {
  rulestack   = cloudngfwaws_rulestack.example.name
  name        = "attack-vpc-summary"
  description = "Also configured by Terraform"
  prefix_list = [
    "10.2.0.0/16"
  ]
  audit_comment = "initial config"
}

resource "cloudngfwaws_prefix_list" "vuln-vpc" {
  rulestack   = cloudngfwaws_rulestack.example.name
  name        = "vulnerable-vpc-summary"
  description = "Also configured by Terraform"
  prefix_list = [
    "10.1.0.0/16"
  ]
  audit_comment = "initial config"
}

resource "cloudngfwaws_security_rule" "example" {
  rulestack   = cloudngfwaws_rulestack.example.name
  rule_list   = "LocalRule"
  priority    = 3
  name        = "tf-security-rule"
  description = "Also configured by Terraform"
  source {
        prefix_lists = [cloudngfwaws_prefix_list.attack-vpc.name]
  }
  destination {
    prefix_lists = [cloudngfwaws_prefix_list.vuln-vpc.name]
  }
  negate_destination = false
  applications       = ["any"]
  category {}
  action        = "Allow"
  logging       = true
  audit_comment = "initial config"
}