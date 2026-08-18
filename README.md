# kubeverse-infra

Infrastructure-as-Code repository for EKS cluster provisioning and Argo CD installation using Terragrunt + OpenTofu.

## Contents

- `modules/eks/`: Reusable OpenTofu module for VPC + EKS cluster
- `modules/argocd/`: Reusable OpenTofu module for Argo CD via Helm
- `live/sandbox/us-east-1/`: Terragrunt live configs for sandbox environment
- `scripts/`: Deployment automation scripts
- `root.hcl`: Root Terragrunt configuration

## Prerequisites

- AWS Account: sandbox-vfde-bss-deployment (004326122988) with FullAdmin role
- CLI tools: `tofu`, `terragrunt`, `kubectl`, `helm`, `aws` (all must be in PATH)
- AWS credentials configured with proper account access
- S3 bucket and DynamoDB table for Terraform state (auto-created or pre-provisioned)

## Deployment

### 1. Clone this repo

```bash
git clone https://github.com/KubeVerse-playground/kubeverse-infra.git
cd kubeverse-infra
```

### 2. Authenticate to AWS

```bash
aws sso login --profile sandbox-fulladmin  # or your auth method
export AWS_PROFILE=sandbox-fulladmin
aws sts get-caller-identity  # Verify Account: 004326122988
```

### 3. Dry-run (Plan)

```bash
cd live/sandbox/us-east-1/eks
terragrunt plan --non-interactive
```

Review the plan output to ensure intended resources.

### 4. Deploy

```bash
./scripts/01-provision.sh
```

This will:
- Run `terragrunt init` for EKS and Argo CD modules
- Apply EKS cluster (VPC, security groups, node groups)
- Apply Argo CD via Helm into the newly created cluster
- Update local kubeconfig

Typical time: 15–20 minutes.

### 5. Verify

```bash
kubectl get nodes
kubectl get pods -n argocd
kubectl get svc -n argocd argocd-server
```

Get the Argo CD LoadBalancer endpoint:

```bash
kubectl get svc -n argocd argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Get the initial admin password:

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo
```

## Cluster Name

EKS cluster is named: **KubeVerse**

## State Management

- Backend: Local state (`.tofu.state/` directory)
- State files are committed to `.gitignore` by default
- For production: Switch to S3 + DynamoDB backend in `root.hcl`

## Next Steps

After cluster and Argo CD are running:

1. Clone `KubeVerse-argocd-admin` (this repo's dependency)
2. Follow deployment steps in `KubeVerse-argocd-admin/README.md`

## Cleanup

To destroy all resources:

```bash
./scripts/02-destroy.sh
```

⚠️ This will delete the EKS cluster and all Argo CD resources.

## Architecture Notes

- **VPC**: 10.40.0.0/16 with 3 AZs, single NAT gateway
- **EKS**: Kubernetes 1.31, t3.medium nodes (2 desired, 1–3 range)
- **Argo CD**: Helm chart v8.0.13 with LoadBalancer service

## Customization

Edit `live/sandbox/us-east-1/eks/terragrunt.hcl` to change:
- Cluster version (`cluster_version`)
- Node type (`node_instance_type`)
- Node count (`desired_size`, `min_size`, `max_size`)
- VPC CIDR (`vpc_cidr`)

Edit `root.hcl` to change:
- AWS region
- Account ID
- Project tags
