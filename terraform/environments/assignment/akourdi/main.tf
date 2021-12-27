#
# Main Terraform configuration for a specific deployment in AWS
#

provider "aws" {
  region = "eu-west-1"
}


module "assignment_deployment" {
  source = "../../../modules/aws-assignment-deployment"
}
