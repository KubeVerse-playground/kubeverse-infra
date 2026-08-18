variable "cluster_name" {
  description = "Target EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS region where EKS is deployed"
  type        = string
}

variable "argocd_chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
}
