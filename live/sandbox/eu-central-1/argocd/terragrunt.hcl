include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  cluster_name = include.root.locals.cluster_name
  aws_region   = include.root.locals.aws_region
}

terraform {
  source = "../../../../modules/argocd"
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  cluster_name         = dependency.eks.outputs.cluster_name
  aws_region           = local.aws_region
  argocd_chart_version = "8.0.13"
}
