# Create Terraform Backend using S3
# https://developer.hashicorp.com/terraform/language/settings/backends/s3
terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-sct6443"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"


    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

# Configure the AWS Provider
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = "us-east-2"
  alias = "primary"
}

provider "aws" {
  region = "us-west-2"
  alias = "replica"
}

module "mysql_primary" {
  source = "../../../../modules/data-stores/mysql"
  
  # Configure AWS Providers
  # https://developer.hashicorp.com/terraform/language/modules/develop/providers
  providers = {
    aws = aws.primary
  }

  db_name  = "stage_db"
  db_username = var.db_username
  db_password = var.db_password
}