#!/bin/bash

echo "Generating Files and Directories..."

# Terraform Files
touch versions.tf main.tf data.tf output.tf provider.tf variables.tf terraform.auto.tfvars.json

# Hooks
touch init-git-hooks.sh
chmod +x init-git-hooks.sh

echo "Files Generated!"

cat << EOF > init-git-hooks.sh
#!/bin/bash

# Init git only if exists

if [[ -n "git --version" ]]; then
    echo "Initializing Git..."
    git init
    echo "Initializing pre-commit hook..."
    cp .git/hooks/pre-commit.sample .git/hooks/pre-commit
    cat hooks/pre-commit > .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "Done!"
fi
EOF

echo "Initializing Git..."
./init-git-hooks.sh

echo "Generating content for Terraform Files..."

cat << EOF > versions.tf
terraform {
    required_version = ">= 1.1.0"

    required_providers {
        # Example provider

        random = {
            source  = "hashicorp/random"
            version = "3.1.2"
        }

        aws = {
            source = "hashicorp/aws"
            version = "4.10.0"
        }
    }

    # No backends
}
EOF

cat << EOF > provider.tf
# An example provider
provider "random" {}

provider "aws" {
  region     = var.default_region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = var.default_tags
  }

  # Assume roles: it is best practice to assume roles in the provider
  # INFO https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#delegate-using-roles

  assume_role {
    role_arn     = var.assumed_role_arn
    session_name = random_string.aws_assume_role_session_name.result
    tags         = var.default_tags
  }
}
EOF

cat << EOF > variables.tf
# Example Variables
variable "default_region" {
  type        = string
  default     = "us-east-1"
  description = "The default region to use for AWS resources."
  nullable    = true

  validation {
    condition     = var.default_region != "" && var.default_region != null
    error_message = "The default region must be a string and a valid of AWS region."
  }
}

variable "default_tags" {
  type        = map(string)
  description = "The default tags to apply to AWS resources."
  nullable    = true
  sensitive   = false
}

variable "access_key" {
  type        = string
  description = "The access key to use for AWS resources."
  sensitive   = true
  # nullable = false

  validation {
    condition     = var.access_key != "" && var.access_key != null
    error_message = "The access key must be a string and a valid of AWS access key."
  }
}

variable "secret_key" {
  type        = string
  description = "The secret key to use for AWS resources."
  sensitive   = true
  # nullable = false

  validation {
    condition     = var.secret_key != "" && var.secret_key != null
    error_message = "The secret key must be a string and a valid of AWS secret key."
  }
}

variable "assumed_role_arn" {
  type        = string
  description = "The ARN of the role to assume."
  nullable    = false
  sensitive   = false

  validation {
    condition     = var.assumed_role_arn != "" && var.assumed_role_arn != null
    error_message = "The assumed role ARN must be supplied and must be a string."
  }
}
EOF

cat << EOF > terraform.auto.tfvars.json
{
    "default_region": "us-east-1",
    "default_tags": {},
    "assumed_role_arn": "arn of role to assume"
}
EOF

cat << EOF > main.tf
resource "random_string" "aws_assume_role_session_name" {
  keepers = {
    "for" = "aws_assume_role"
  }

  length           = 20
  min_lower        = 5
  min_special      = 5
  min_upper        = 5
  override_special = "=,.@-"
  special          = false
}
EOF

cat << EOF > data.tf
output "aws_assumed_role_session_name" {
  value = random_string.aws_assume_role_session_name.result
}
EOF

exit 0;
