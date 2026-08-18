#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIVE_DIR="${ROOT_DIR}/live/sandbox/eu-central-1"

cd "${LIVE_DIR}/argocd"
echo "=== Destroying Argo CD stack ==="
terragrunt destroy --non-interactive -auto-approve

cd "${LIVE_DIR}/eks"
echo "=== Destroying EKS stack ==="
terragrunt destroy --non-interactive -auto-approve

echo "All resources destroyed for sandbox stack."
