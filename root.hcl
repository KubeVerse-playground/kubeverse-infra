locals {
  environment    = var.environment
  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  cluster_name   = var.cluster_name

  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terragrunt-OpenTofu"
    Project     = "KubeVerse"
  }
}

remote_state {
  backend = "local"

  config = {
    path = "${dirname(find_in_parent_folders("root.hcl"))}/.tofu.state/${path_relative_to_include()}/tofu.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = {
      Environment = "${local.environment}"
      ManagedBy   = "Terragrunt-OpenTofu"
      Project     = "KubeVerse"
    }
  }
}
EOF
}
