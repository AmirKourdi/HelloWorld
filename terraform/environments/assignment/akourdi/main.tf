#
# Main Terraform configuration for a specific deployment in AWS
#

provider "aws" {
  region = "eu-west-1"
}

locals {
  ami_owner          = "721645178643"
  admin_ami          = "assignment-v9-admin-final"
  candidate_name     = "assignment"
  assignment_version = "v9"
  env                = "stage-v9"
}

module "assignment_deployment" {
  source = "../../../modules/aws-assignment-deployment"


}
