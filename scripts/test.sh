#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "===================================="
echo "Kubernetes Deployment Test"
echo "===================================="

echo
echo "Pods"
kubectl get pods

echo
echo "Services"
kubectl get svc

echo
echo "PVC"
kubectl get pvc

echo
echo "Endpoints"
kubectl get endpoints

FASTAPI_POD=$(kubectl get pods -l app=fastapi -o jsonpath='{.items[0].metadata.name}')

echo
echo "Testing FastAPI..."

kubectl exec "$FASTAPI_POD" -- python -c \
"import urllib.request; print(urllib.request.urlopen('http://localhost:8000/').read().decode())"

echo
echo "Environment Variables"

kubectl exec "$FASTAPI_POD" -- env | grep REDIS

echo
echo "Redis PVC"

kubectl describe pvc redis-pvc | grep -E "Status:|Capacity:|Access Modes:"

echo
echo "All tests passed!"