# Kubernetes Configuration

This directory contains Kubernetes manifests and configurations for homelab services.

## Structure

```
kubernetes/
├── namespaces/        # Namespace definitions
├── deployments/       # Application deployments
├── services/          # Service definitions
├── ingress/          # Ingress rules
├── configmaps/       # ConfigMaps
├── secrets/          # Secret templates (actual secrets not in git)
└── monitoring/       # Monitoring specific k8s resources
```

## Prerequisites

- Kubernetes cluster (k3s, k0s, or full k8s)
- kubectl configured
- Helm (optional, for package management)

## Quick Start

### Deploy a Namespace

```bash
kubectl apply -f namespaces/
```

### Deploy Services

```bash
kubectl apply -f deployments/
kubectl apply -f services/
```

### Check Status

```bash
kubectl get pods -A
kubectl get services -A
```

## Common Commands

```bash
# Apply all configurations
kubectl apply -f kubernetes/ -R

# Get all resources in a namespace
kubectl get all -n <namespace>

# View logs
kubectl logs -f <pod-name> -n <namespace>

# Describe resource
kubectl describe <resource-type> <resource-name> -n <namespace>

# Delete resources
kubectl delete -f <file.yaml>
```

## Storage

Configure persistent volume claims for stateful services:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: service-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

## Networking

- Use Services for internal communication
- Use Ingress for external access
- Consider using a service mesh for advanced networking

## Secrets Management

**Never commit actual secrets to git!**

Create secrets from files:
```bash
kubectl create secret generic my-secret --from-file=secret.txt
```

Or from literal values:
```bash
kubectl create secret generic my-secret --from-literal=password=changeme
```

## Helm Charts

If using Helm for package management:

```bash
# Add repository
helm repo add <repo-name> <repo-url>

# Install chart
helm install <release-name> <chart-name> -n <namespace>

# Upgrade release
helm upgrade <release-name> <chart-name> -n <namespace>
```

## Backup

Backup important resources:

```bash
# Backup all resources in a namespace
kubectl get all -n <namespace> -o yaml > backup.yaml

# Use Velero for cluster-wide backups
```

## Troubleshooting

```bash
# Pod not starting
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>

# Service not accessible
kubectl get endpoints <service-name> -n <namespace>

# Check events
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```
