#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "===================================="
echo "Deploying Redis Lab to Kubernetes..."
echo "===================================="

echo "Applying ConfigMap..."
kubectl apply -f "$PROJECT_ROOT/k8s/configmap.yaml"

echo "Applying Secret..."
kubectl apply -f "$PROJECT_ROOT/k8s/secret.yaml"

echo "Applying PVC..."
kubectl apply -f "$PROJECT_ROOT/k8s/pvc.yaml"

echo "Deploying Redis..."
kubectl apply -f "$PROJECT_ROOT/k8s/redis-deployment.yaml"
kubectl apply -f "$PROJECT_ROOT/k8s/redis-service.yaml"

echo "Deploying FastAPI..."
kubectl apply -f "$PROJECT_ROOT/k8s/deployment.yaml"
kubectl apply -f "$PROJECT_ROOT/k8s/service.yaml"

echo
echo "Waiting for Deployments..."

kubectl rollout status deployment/redis-deployment
kubectl rollout status deployment/fastapi-deployment

echo
echo "Deployment complete!"

echo
kubectl get pods

echo
kubectl get svc

echo
kubectl get pvc