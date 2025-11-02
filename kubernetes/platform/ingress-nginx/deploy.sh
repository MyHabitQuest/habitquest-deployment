#!/bin/sh

set -euo pipefail

echo "\n Installing ingress-nginx..."

kubectl apply -k resources

echo "\n ingress-nginx installation completed.\n"