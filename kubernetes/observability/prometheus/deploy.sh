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

# create namespace if missing
if ! kubectl get ns "$NAMESPACE" >/dev/null 2>&1; then
  kubectl create namespace "$NAMESPACE"
fi

# add / update helm repo
helm repo add prometheus-community "$CHART_REPO" 2>/dev/null || true
helm repo update

# install or upgrade the chart
helm upgrade --install "$RELEASE_NAME" "$CHART_NAME" \
  --namespace "$NAMESPACE" \
  -f "$VALUES_FILE" \
  --wait --timeout "$HELM_TIMEOUT"

echo "Prometheus helm release '$RELEASE_NAME' installed in namespace '$NAMESPACE'."
echo "Pods:"
kubectl get pods -n "$NAMESPACE" -o wide

echo "To access Prometheus:"
kubectl get svc -n "$NAMESPACE"