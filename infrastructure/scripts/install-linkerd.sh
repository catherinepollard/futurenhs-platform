#!/bin/bash
set -eu

CURRENT_CLUSTER=$(kubectl config current-context)

while true; do
    read -p "The current cluster is $CURRENT_CLUSTER. Are you sure you would like to add Linkerd to this cluster? (y/n)" yn
    case $yn in
        [Yy]* )
            echo "Verifying cluster"
            linkerd check --pre || { echo 'Cluster validation failed. Please fix issues before proceeding. Perhaps you already have Linkerd installed?' ; exit 1; }
            echo "Installing Linkerd"
            linkerd install | kubectl apply -f - || { echo 'Unable to apply to cluster.' ; exit 1; }
            echo "Please wait a few minutes for the cluster to pull the Linkerd images and then run 'linkerd check' to verify the installation."
            
        break;;
        [Nn]* ) echo "You may wish to use the commands 'az account set' and 'az aks get-credentials' to change cluster."; exit;;
        * ) echo "Please answer 'yes' or 'no'.";;
    esac
done
