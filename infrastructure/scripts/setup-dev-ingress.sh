#!/bin/bash

set -eu

NAME="${1:?"Please enter your name as first argument"}"
EMAIL="${2:?"Please enter your email address as first argument"}"
REGION="${3:-westeurope}"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo " > Create temp dir"
mkdir -p "$CURRENT_DIR/../environments/dev/k8s/.temp"

echo " > Combine Ingress Manifests"
kustomize build "$CURRENT_DIR/../environments/dev/k8s/ingress" > "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
kustomize build "$CURRENT_DIR/../environments/dev/k8s/certificate/issuer" > "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-issuer.yaml"
kustomize build "$CURRENT_DIR/../environments/dev/k8s/certificate/manager" > "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-manager.yaml"

echo " > Set vars in build file"
sed -i "" "s/--USERNAME--/$NAME/g" "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
sed -i "" "s/--DNS_PREFIX--/$NAME/g" "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
sed -i "" "s/--REGION--/$REGION/g" "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
sed -i "" "s/--EMAIL--/$EMAIL/g" "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"
sed -i "" "s/--EMAIL--/$EMAIL/g" "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-issuer.yaml"

echo " > Setup Hello World Service"
kubectl apply -f "$CURRENT_DIR/../../hello-world/dev"

echo " > Setup Ingress Service"
kubectl apply -f "$CURRENT_DIR/../environments/dev/k8s/.temp/ingress.yaml"

echo " > Setup Certificate Manager"
kubectl apply -f "$CURRENT_DIR/../environments/dev/k8s/.temp/certificate-manager.yaml"

echo "After a minute or two, you will be able to browse to:"
echo "https://$NAME.$REGION.cloudapp.azure.com/hello/$NAME"
echo "The browser will moan that this certificate is fake."
echo "That's because it's a staging certificate."
echo "Click Advanced, and Proceed"

echo " > Script complete"
