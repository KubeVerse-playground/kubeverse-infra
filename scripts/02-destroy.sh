#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Set via environment variable or .env file
LIVE_DIR="${LIVE_DIR:-${ROOT_DIR}/live/sandbox/$(aws configure get region --output text)}"

cd "${LIVE_DIR}/argocd"
echo "=== Destroying Argo CD stack ==="
terragrunt destroy --non-interactive -auto-approve

cd "${LIVE_DIR}/eks"
echo "=== Destroying EKS stack ==="
terragrunt destroy --non-interactive -auto-approve

echo "All resources destroyed for sandbox stack."
