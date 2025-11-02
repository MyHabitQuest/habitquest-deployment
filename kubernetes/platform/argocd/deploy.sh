#!/bin/sh

set -euo pipefail

echo "\nInstalling ArgoCD..."

kubectl apply -k resources

echo "\nArgoCD installation completed.\n"