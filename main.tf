terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.24"
    }
    humanitec = {
      source = "humanitec/humanitec"
      version = "~> 0.11.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region     = "eu-west-2"
}

provider "humanitec" {
  # example configuration here
}

module "aws_s3" {
  source = "terraform-aws-modules/s3-bucket/aws"

  // Generate randome bucket name
  bucket = "ht-bucket-${lower(random_string.s3_bucket_name.result)}"

}

resource "random_string" "s3_bucket_name" {
  length  = 8
  special = false
}

resource "humanitec_resource_definition" "s3" {
  id   = "existing-s3"
  name = "existing-s3"
  type = "s3"

  driver_type = "humanitec/echo"
  driver_inputs = {
    values = {
      region = module.aws_s3.s3_bucket_region
      bucket = module.aws_s3.s3_bucket_bucket_domain_name
    }
  }

  criteria = [
    {
      app_id = "my-app"
      env_id = "production"
    }
  ]
}