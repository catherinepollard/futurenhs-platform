#!/bin/bash

set -eu

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Deleting Hello World"
kubectl delete -f "$CURRENT_DIR/../../hello-world/dev"

echo "Deleting Ingress Service"
kubectl delete -f $CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml

echo "Deleting Cert Manager"
kubectl delete ns cert-manager

echo "Deleting temp manifests"
rm "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
rm "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate.yaml"
rmdir "$CURRENT_DIR/../environments/dev/k8s/.temp"