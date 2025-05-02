terraform {
  # If you use any other providers you should also pin them to the
  # major version currently being used.  This practice will help us
  # avoid unwelcome surprises.
  required_providers {
    # Version 5.x is required in order to use the "Decompression" processor in
    # the aws_kinesis_firehose_delivery_stream resource (part of the
    # extended_s3_configuration).
    # This comment should be removed when all of our Terraform modules have
    # migrated to version 5.x.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  # Version 1.1 of Terraform is the first version to support the
  # nullable key in variable definitions.
  required_version = "~> 1.1"
}
