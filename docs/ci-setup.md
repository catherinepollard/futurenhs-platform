# 1. Setting registry and cluster

GitHub Actions is set up to push docker images to the 'fnhsproduction' registry in the 'production' cluster.

If you want to push to another registry or another cluster then a new set of secrets need to be generated and edited in the GitHub repository.

Follow the instructions here for [secret generation](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-github-action)

# 2. Authenticate with Azure Container Registry (ACR) from Azure Kubernetes Service (AKS)

Once there is a change in registry or cluster you will need to re-establish authentication between ACR and AKS.
[Configure ACR integration for existing AKS clusters](https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration).
