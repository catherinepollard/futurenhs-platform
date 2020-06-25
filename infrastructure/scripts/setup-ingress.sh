#!/bin/bash

set -eu

NAME="${1:?"Please enter your name as first argument"}"
EMAIL="${2:?"Please enter your email address as second argument"}"
ENV="${3:-dev}"
REGION="${4:-westeurope}"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
DNS_PREFIX=$NAME
if [ $ENV == "prod" ]; then
  DNS_PREFIX="fnhs"
fi

echo " > Setup Hello World Service"
# hello-world/dev used because currently no prod version
kubectl apply -f "$CURRENT_DIR/../../hello-world/dev"

echo " > Combine and execute Ingress Manifests (Step 1)"
kustomize build "$CURRENT_DIR/../kubernetes/ingress/step1/$ENV" --reorder none |
  sed \
    -e "s/--USERNAME--/$NAME/g" \
    -e "s/--DNS_PREFIX--/$DNS_PREFIX/g" \
    -e "s/--REGION--/$REGION/g" \
    -e "s/--EMAIL--/$EMAIL/g" |
  kubectl apply -f -

echo " > Waiting for cert-manager deployment to be loaded"
kubectl rollout status deployment cert-manager-webhook -n cert-manager

echo " > Waiting for ingress-nginx-controller deployment to be loaded"
kubectl rollout status deployment ingress-nginx-controller -n ingress-nginx

echo " > Combine and execute Ingress Manifests (Step 2)"
kustomize build "$CURRENT_DIR/../kubernetes/ingress/step2/$ENV" --reorder none |
  sed \
    -e "s/--USERNAME--/$NAME/g" \
    -e "s/--DNS_PREFIX--/$DNS_PREFIX/g" \
    -e "s/--REGION--/$REGION/g" \
    -e "s/--EMAIL--/$EMAIL/g" |
  kubectl apply -f -

echo "After a minute or two, you will be able to browse to:"
printf "\nhttps://$DNS_PREFIX.$REGION.cloudapp.azure.com/hello/$NAME\n\n"
echo "The browser will moan that this certificate is fake."
echo "That's because it's a staging certificate."
echo "Click Advanced, and Proceed"

echo " > Script complete"
