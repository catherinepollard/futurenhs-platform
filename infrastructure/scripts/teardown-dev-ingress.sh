#!/bin/bash

set -eu

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Deleting Hello World"
kubectl delete -f "$CURRENT_DIR/../../hello-world/dev"

echo "Deleting Ingress Service"
kubectl delete -f "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"

echo "Deleting Certificate Manager"
kubectl delete -f "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-manager.yaml"

echo "Deleting temp manifests"
rm "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
rm "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-issuer.yaml"
rm "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-manager.yaml"
rmdir "$CURRENT_DIR/../environments/dev/k8s/.temp"
