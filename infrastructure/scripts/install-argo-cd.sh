#!/bin/bash
set -eu

CURRENT_CLUSTER=$(kubectl config current-context)

while true; do
    read -p "The current cluster is $CURRENT_CLUSTER. Are you sure you would like to add Argo CD to this cluster? (y/n)" yn
    case $yn in
        [Yy]* )
            echo "Create namespace"
            kubectl create namespace argocd || { echo 'Create namespace argocd failed. Please fix issues before proceeding. Perhaps you have already created an argocd namespace?' ; exit 1; }
            echo "Installing Argo CD"
            kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || { echo 'Unable to install.' ; exit 1; }
            echo Pods will need to be in a running state before you can move forward. These need to be in a running state before you can move forward. Use 'watch kubectl get pods -n argocd' to check"

        break;;
        [Nn]* ) echo "You may wish to use the commands 'az account set' and 'az aks get-credentials' to change cluster."; exit;;
        * ) echo "Please answer 'yes' or 'no'.";;
    esac
done
