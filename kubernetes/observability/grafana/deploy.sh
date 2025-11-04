#!/bin/sh

set -euo pipefail

cd "$(dirname "$0")"

RELEASE_NAME="${RELEASE_NAME:-crewcash-grafana}"
NAMESPACE="${NAMESPACE:-grafana}"
CHART_REPO="${CHART_REPO:-https://grafana.github.io/helm-charts}"
CHART_NAME="${CHART_NAME:-grafana/grafana}"
VALUES_FILE="${VALUES_FILE:-resources/values.yml}"
LOCAL_PORT="${LOCAL_PORT:-3000}"
HELM_TIMEOUT="${HELM_TIMEOUT:-300s}"

# create namespace
if ! kubectl get ns "$NAMESPACE" >/dev/null 2>&1; then
  kubectl create namespace "$NAMESPACE"
fi

# add/update repo
helm repo add grafana "$CHART_REPO" 2>/dev/null || true
helm repo update

# install/upgrade
helm upgrade --install "$RELEASE_NAME" "$CHART_NAME" -n "$NAMESPACE" -f "$VALUES_FILE" --wait --timeout "$HELM_TIMEOUT"
echo "Grafana release '$RELEASE_NAME' installed in namespace '$NAMESPACE'."