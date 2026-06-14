# DevOps Assignment

## Overview

This repository contains a production-oriented deployment implementation for the provided Go application.

The solution demonstrates:

- Containerization using Docker
- CI/CD using GitHub Actions
- Kubernetes deployment using Kustomize
- GitOps deployment using ArgoCD
- Infrastructure provisioning using Terraform
- Configuration management using Ansible
- High Availability
- Scalability
- Security Best Practices

---

# Repository Structure

```text
.
├── .github/workflows/
│   └── go.yml
│
├── ansible/
│   ├── inventory/
│   │   └── hosts.ini
│   ├── playbooks/
│   │   └── site.yml
│   ├── roles/
│   │   ├── common/
│   │   ├── docker/
│   │   ├── nginx/
│   │   └── node_exporter/
│   └── ansible.cfg
│
├── argocd/
│   └── application.yml
│
├── kustomize/
│   ├── base/
│   │   ├── deployment.yml
│   │   ├── service.yml
│   │   ├── hpa.yml
│   │   ├── pdb.yml
│   │   └── kustomization.yml
│   │
│   └── overlays/prod/
│       ├── namespace.yml
│       ├── patch.yml
│       └── kustomization.yml
│
├── terraform/
│   ├── provider.tf
│   ├── version.tf
│   ├── vpc.tf
│   ├── gke.tf
│   ├── nodepool.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── Dockerfile
├── main.go
├── main_test.go
├── go.mod
└── README.md
```

---

# Application

A simple Go HTTP application exposing port `8080`.

Example:

```bash
curl "http://localhost:8080?name=Shaun"
```

Response:

```text
Hello Shaun
```

---

# Docker

## Features

- Multi-stage build
- Minimal runtime image
- Non-root execution
- Hardened container principles
- Optimized image size

## Build Image

```bash
docker build -t thurazaw000/devops-assignment:v1.0.0 .
```

## Push Image

```bash
docker push thurazaw000/devops-assignment:v1.0.0
```

## Docker Hub

https://hub.docker.com/r/thurazaw000/devops-assignment

---

# Kubernetes Deployment

Kustomize is used to manage Kubernetes manifests.

## Base Resources

- Deployment
- Service
- Horizontal Pod Autoscaler
- Pod Disruption Budget

## Production Overlay

- Namespace configuration
- Replica customization
- Environment-specific overrides

---

# High Availability

Implemented through:

### Multiple Replicas

```yaml
replicas: 3
```

### Rolling Updates

```yaml
maxUnavailable: 1
maxSurge: 1
```

### Pod Anti-Affinity

Distributes replicas across available nodes whenever possible.

### Pod Disruption Budget

```yaml
minAvailable: 2
```

Ensures application availability during maintenance operations.

---

# Scalability

Horizontal Pod Autoscaler configured:

```yaml
minReplicas: 2
maxReplicas: 5
targetCPUUtilizationPercentage: 70
```

The application automatically scales based on CPU utilization.

---

# Security

Implemented security controls:

```yaml
securityContext:
  runAsUser: 1000
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
```

Additional protections:

- Non-root container execution
- Resource limits
- Namespace isolation
- Immutable image versioning

---

# Deploy with Kustomize

Create namespace:

```bash
kubectl create namespace production
```

Deploy:

```bash
kubectl apply -k kustomize/overlays/prod
```

Verify:

```bash
kubectl get all -n production
```
<img width="1972" height="456" alt="image" src="https://github.com/user-attachments/assets/34338d01-a4ad-4263-963f-ec01fd845bef" />

---

# ArgoCD (GitOps)

ArgoCD is configured to deploy the application declaratively from Git.

Application manifest:

```text
argocd/application.yml
```

Deploy ArgoCD Application:

```bash
kubectl apply -f argocd/application.yml
```

Features:

- Automated Sync
- Self-Healing
- Drift Detection
- Declarative GitOps Deployment

<img width="1784" height="1150" alt="image" src="https://github.com/user-attachments/assets/4bb2f822-672d-4590-905c-5cd8c704959e" />

<img width="2840" height="1408" alt="image" src="https://github.com/user-attachments/assets/d5569fb8-cf29-4877-8834-571aa2ebc6a8" />

---

# Terraform Infrastructure

Terraform provisions:

- VPC
- Subnet
- GKE Cluster
- Node Pool
- Networking Resources

Terraform files:

```text
terraform/
```

Initialize:

```bash
terraform init
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

---

# Workload Identity

The solution avoids injecting static GCP access keys into application containers.

Workload Identity is used to provide secure access to Google Cloud resources following GKE security best practices.

---

# CI/CD Pipeline

GitHub Actions workflow:

```text
.github/workflows/go.yml
```

Pipeline stages:

1. Checkout Source
2. Run Go Tests
3. Build Docker Image
4. Push Image to Docker Hub

This ensures only validated code is packaged and published.

---

# Ansible Automation

Ansible provisions Linux hosts according to assignment requirements.

## Tasks Performed

### Common

- Update OS packages

### Docker

- Install Docker
- Configure log rotation

### NGINX

- Run NGINX container
- Deploy custom HTML template
- Configure restart policy
- Expose HTTP service

### Node Exporter

- Install Node Exporter
- Create dedicated non-login system user
- Configure systemd service

---

## Execute Ansible

```bash
cd ansible

ansible-playbook \
-i inventory/hosts.ini \
playbooks/site.yml
```
<img width="2016" height="1360" alt="image" src="https://github.com/user-attachments/assets/def826dc-1163-4800-a384-45094cee00f0" />
<img width="1424" height="414" alt="image" src="https://github.com/user-attachments/assets/9f6420aa-8dbe-45ca-ab67-78cb92edc5f4" />

---

# Local Validation

Kubernetes manifests were validated using Kind.

Cluster:

```bash
kind get clusters
```

Example:

```text
devops-test
```
<img width="924" height="60" alt="image" src="https://github.com/user-attachments/assets/62e6a767-dd76-4c61-9fa3-63b5cb8a6321" />


The same manifests are designed for deployment to GKE provisioned through Terraform.

---

# Assignment Requirement Coverage

| Requirement | Status |
|------------|---------|
| Dockerfile | ✅ |
| Multi-stage Build | ✅ |
| Docker Hub Push | ✅ |
| Kustomize | ✅ |
| Resource Requests/Limits | ✅ |
| Health Probes | ✅ |
| Rolling Updates | ✅ |
| Pod Disruption Budget | ✅ |
| Anti-Affinity | ✅ |
| Security Context | ✅ |
| HPA | ✅ |
| ArgoCD GitOps | ✅ |
| Terraform GKE | ✅ |
| VPC/Subnet Provisioning | ✅ |
| Workload Identity Design | ✅ |
| Ansible Automation | ✅ |
| Node Exporter | ✅ |
| NGINX Container | ✅ |
| Docker Log Rotation | ✅ |

---

# Author

**Thura Zaw (Shaun Gautham)**

DevOps Engineer
