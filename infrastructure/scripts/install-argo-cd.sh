#!/bin/bash
set -eu

# https://stackoverflow.com/a/1482133
cd $(dirname "$0")

CURRENT_CLUSTER=$(kubectl config current-context)

while true; do
    read -p "The current cluster is $CURRENT_CLUSTER. Are you sure you would like to add Argo CD to this cluster? (y/n)" yn
    case $yn in
        [Yy]* )
            echo "Installing Argo CD CLI"
            brew install argoproj/tap/argocd || { echo 'Unable to install.' ; exit 1;  }
            echo "Create namespace"
            kubectl apply -f ../kubernetes/argocd-setup/namespace.yaml
            echo "Installing Argo CD"
            kubectl apply -n argocd -f ../kubernetes/argocd-setup/install.yaml
            echo "Pods will need to be in a running state before you can move forward. These need to be in a running state before you can move forward. Use 'watch kubectl get pods -n argocd' to check"
            echo "Creating deployment in Argo CD"
            kubectl apply -n argocd -f ../kubernetes/argocd-setup/
        break;;
        [Nn]* ) echo "You may wish to use the commands 'az account set' and 'az aks get-credentials' to change cluster."; exit;;
        * ) echo "Please answer 'yes' or 'no'.";;
    esac
done
