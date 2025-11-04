#!/bin/sh

set -euo pipefail

cd "$(dirname "$0")"

RELEASE_NAME="${RELEASE_NAME:-crewcash-prometheus}"
NAMESPACE="${NAMESPACE:-prometheus-system}"
CHART_REPO="${CHART_REPO:-https://prometheus-community.github.io/helm-charts}"
CHART_NAME="${CHART_NAME:-prometheus-community/prometheus}"
VALUES_FILE="${VALUES_FILE:-resources/values.yml}"
HELM_TIMEOUT="${HELM_TIMEOUT:-600s}"

echo "Installing Prometheus (release: $RELEASE_NAME namespace: $NAMESPACE) ..."

command -v helm >/dev/null 2>&1 || { echo "helm not found in PATH"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found in PATH"; exit 1; }

# create namespace if missing
if ! kubectl get ns "$NAMESPACE" >/dev/null 2>&1; then
  kubectl create namespace "$NAMESPACE"
fi

# add / update helm repo
helm repo add prometheus-community "$CHART_REPO" 2>/dev/null || true
helm repo update

# build values args if a values file exists
VALUES_ARGS=""
if [ -f "$VALUES_FILE" ]; then
  VALUES_ARGS="-f $VALUES_FILE"
fi

# install or upgrade the chart
helm upgrade --install "$RELEASE_NAME" "$CHART_NAME" \
  --namespace "$NAMESPACE" \
  $VALUES_ARGS \
  --wait --timeout "$HELM_TIMEOUT"

echo "Prometheus helm release '$RELEASE_NAME' installed in namespace '$NAMESPACE'."
echo "Pods:"
kubectl get pods -n "$NAMESPACE" -o wide

echo "To access Prometheus / Grafana, inspect services in namespace '$NAMESPACE':"
kubectl get svc -n "$NAMESPACE"