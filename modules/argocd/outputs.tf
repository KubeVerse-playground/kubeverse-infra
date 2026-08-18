output "argocd_namespace" {
  description = "Namespace where Argo CD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_admin_secret_name" {
  description = "Initial Argo CD admin password secret"
  value       = "argocd-initial-admin-secret"
}
