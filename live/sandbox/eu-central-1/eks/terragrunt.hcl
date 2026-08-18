include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  cluster_name = include.root.locals.cluster_name
  aws_region   = include.root.locals.aws_region
  common_tags  = include.root.locals.common_tags
  vpc_id       = "vpc-038012c6a80998784"  # vfde-sandbox-eucentral1-main
}

terraform {
  source = "../../../../modules/eks"
}

inputs = {
  cluster_name       = local.cluster_name
  aws_region         = local.aws_region
  vpc_id             = local.vpc_id
  subnet_ids         = []  # Will be populated by data source in module
  vpc_cidr           = ""
  cluster_version    = "1.31"
  node_instance_type = "t3.medium"
  desired_size       = 2
  min_size           = 1
  max_size           = 3
  tags               = local.common_tags
}
