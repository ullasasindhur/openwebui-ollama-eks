# openwebui-ollama-eks

A project to deploy the Open WebUI application and connect it with Ollama in AWS EKS.

## Project Overview

This project automates the deployment of Open WebUI and Ollama on an Amazon Elastic Kubernetes Service (EKS) cluster. It leverages Terraform for infrastructure provisioning (VPC, EKS cluster, Node Groups) and Kubernetes manifests for deploying the applications.

## Deployment Steps

Follow these steps to deploy Open WebUI and Ollama on your AWS EKS cluster.

### Prerequisites

*   **AWS CLI:** Configured with appropriate credentials and default region.
*   **Terraform:** Installed and configured.
*   **kubectl:** Installed and configured.

### 1. Terraform Initialization and Deployment

Navigate to the `terraform` directory, initialize Terraform, and apply the configuration.

```bash
cd terraform
terraform init
terraform apply --auto-approve
```

This will provision the following AWS resources:

*   A new VPC with public and private subnets.
*   NAT Gateway for outbound internet access from private subnets.
*   An EKS cluster.
*   An EKS managed node group with `t4g.xlarge` instances.

### 2. Configure kubeconfig

After the EKS cluster is created, update your `kubeconfig` file to connect `kubectl` to your new EKS cluster.

```bash
aws eks update-kubeconfig --region us-east-1 --name openwebui-ollama-eks
```

### 3. Deploy Open WebUI and Ollama to Kubernetes

Apply the Kubernetes manifests to deploy Ollama and Open WebUI to your EKS cluster.

```bash
kubectl apply -f .\k8s\ollama.yaml -f .\k8s\webui.yaml
```

### 4. Verify Deployment

Check the status of your deployments and services.

```bash
kubectl get all
```

You should see the Ollama and Open WebUI pods, deployments, and services running.

## Configuration Details

### AWS Region

The AWS region for deployment is `us-east-1`. This can be changed in the `terraform/variables.tf` file if needed.

### VPC Configuration

The VPC is configured with:

*   **CIDR:** Defined by `var.vpc_cidr` (e.g., "10.0.0.0/16").
*   **Private Subnets:** `10.0.1.0/24`, `10.0.2.0/24`
*   **Public Subnets:** `10.0.50.0/24`, `10.0.51.0/24`
*   **NAT Gateway:** Enabled for private subnet internet access.

These values can be modified in `terraform/main.tf` or `terraform/variables.tf`.

### EKS Cluster

*   **Kubernetes Version:** `var.kubernetes_version` (e.g., "1.28").
*   **Node Group Instance Type:** `t4g.xlarge` (ARM64 Graviton instances).
*   **AMI Type:** `AL2023_ARM_64_STANDARD`.
*   **Desired Node Count:** Currently set to `2` (can be modified in `terraform/main.tf`).

### Kubernetes Manifests

*   `k8s/ollama.yaml`: Defines the deployment and service for the Ollama application.
*   `k8s/webui.yaml`: Defines the deployment and service for the Open WebUI application.

You can modify these YAML files to adjust resource limits, environment variables, or other Kubernetes-specific settings.

## Reference
* [Open WebUI](https://github.com/open-webui/open-webui)
* [Ollama](https://ollama.ai/)
* [Configuration - Kubernetes](https://github.com/open-webui/open-webui/tree/main/kubernetes/manifest/base)
* [EKS Module - Terraform](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
* [VPC Module - Terraform](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
