#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIVE_DIR="${ROOT_DIR}/live/sandbox/eu-central-1"
CLUSTER_NAME="kubeverse-prod"
REGION="eu-central-1"

cd "${LIVE_DIR}/eks"
echo "=== Initializing EKS stack ==="
terragrunt init --non-interactive
echo "=== Applying EKS stack ==="
terragrunt apply --non-interactive -auto-approve

cd "${LIVE_DIR}/argocd"
echo "=== Initializing Argo CD stack ==="
terragrunt init --non-interactive
echo "=== Applying Argo CD stack ==="
terragrunt apply --non-interactive -auto-approve

echo "=== Updating kubeconfig ==="
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${REGION}"
kubectl get nodes

echo "Infrastructure and Argo CD installation completed."
