# Infrastructure

We use [Terraform](https://www.terraform.io/) to build our environments.

## Prerequisites

1. Install Terraform:

   ```bash
   brew install terraform
   ```

1. Install a Terraform version switcher:
   ([Terraform Switcher](https://github.com/warrensbox/terraform-switcher)
   or [CHTF](https://github.com/Yleisradio/homebrew-terraforms))

   ```bash
   brew install warrensbox/tap/tfswitch
   ```

   or

   ```bash
   brew install chtf
   ```

1. Select version 0.12.25:

   ```bash
   tfswitch 0.12.25
   ```

   or

   ```bash
   chtf 0.12.25
   ```

1. Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest):

   ```bash
   brew install azure-cli
   ```

1. Login to Azure:

   ```bash
   az login
   ```

1. Install the [Linkerd CLI](https://linkerd.io/2/getting-started/):

   ```bash
   brew install linkerd
   ```
   
1. Install [Kustomize](https://github.com/kubernetes-sigs/kustomize):

   ```bash
   brew install kustomize
   ```

## Development Environment

Infrastructure is set up so that each developer can create their own instance of the environment in Azure,
as opposed to sharing a staging environment.

1. Clone the FutureNHS Platform.

1. Set **your name** and **email** as variables in your terminal, because we'll need to use it several times

    If your name is **John** and you work for the **NHS**, your commands might be as follows:
    
    ```bash
    FNHSNAME=john
    FNHSEMAIL=john@nhs.uk
    ```
   
1. Create the new dev environment with **your name** as the parameter.
    
    ```bash
    ./infrastructure/scripts/create-dev-environment.sh $FNHSNAME
    ```
   
1. Change directory into the dev environment folder:

   ```bash
   cd infrastructure/environments/dev
   ```

1. Run Terraform Init using the vars file you just created:

   ```bash
   terraform init -backend-config=terraform.tfvars
   ```

1. Create an execution plan:

   ```bash
   terraform plan
   ```

1. After verifying the plan above, apply changes. The infrastructure will be created in Azure.

   ```bash
   terraform apply
   ```

1. Give the Kubernetes cluster permissions to pull images from our Docker registry.

   ```bash
   az aks update -n dev-$FNHSNAME -g platform-dev-$FNHSNAME --attach-acr "/subscriptions/75173371-c161-447a-9731-f042213a19da/resourceGroups/platform-production/providers/Microsoft.ContainerRegistry/registries/fnhsproduction"
   ```

1. In order to use Kubernetes CLI (kubectl) commands, you need to pull the credentials from the server.
   
    ```bash
    az aks get-credentials --resource-group platform-dev-$FNHSNAME --name dev-$FNHSNAME
    ``` 

1. To install the [Linkerd](https://linkerd.io/) control plane, run the `install-linkerd.sh` script that can be found within `infrastructure/scripts` directory.

   ```bash
   ./infrastructure/scripts/install-linkerd.sh
   ```

   Once installed, view the Linkerd dashboard with the following command:

   ```bash
   linkerd dashboard &
   ```

1. To install [Argo CD](https://argoproj.github.io/argo-cd/) run the `install-argo-cd.sh` script that can be found within `infrastructure/scripts` directory.

   ```bash
   ./install-argo-cd.sh
   ```

   If you want to view the Argo CD UI, do:

   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

   and browse to http://localhost:8080.

   If you want to see the next.js frontend app UI, do:

   ```bash
   kubectl port-forward deployments/frontend 3000
   ```

   and browse to http://localhost:3000.

1.  Apply the ConfigMap for Azure Monitor for Containers to collect data in the Log Analytics workspace.  The ConfigMap can be found in `infrastructure/kubernetes/logging` directory.
   ```bash
   kubectl apply -f container-azm-ms-agentconfig.yaml
   ```

1. Spin up an Ingress Controller with your **name** and **email** as parameters. 

    This also creates a Load Balancer with a Public IP, creates a temporary domain, 
    and registers a TLS Certificate with your temporary domain. 
    
    ```bash
    ./infrastructure/scripts/setup-dev-ingress.sh $FNHSNAME $FNHSEMAIL
    ```

1. To reduce infrastructure costs for the NHS, please destroy your environment when you no longer need it.

   ```bash
   ./infrastructure/scripts/teardown-dev-ingress.sh
   ```
   
   ```bash
   terraform destroy
   ```

## Production environment

Production is a long-lived environment. To make changes, follow these steps.

The `ARM_SUBSCRIPTION_ID` environment variable is needed if you're using Azure CLI authentication and production is not your default subscription (which is recommended).

1. Change directory into the dev environment folder:

   ```bash
   cd infrastructure/environments/production
   ```

1. Run Terraform Init using the vars file you just created:

   ```bash
   ARM_SUBSCRIPTION_ID=75173371-c161-447a-9731-f042213a19da terraform init
   ```

1. Create an execution plan:

   ```bash
   ARM_SUBSCRIPTION_ID=75173371-c161-447a-9731-f042213a19da terraform plan
   ```

1. After verifying the plan above, apply changes. The infrastructure will be created in Azure.

   ```bash
   ARM_SUBSCRIPTION_ID=75173371-c161-447a-9731-f042213a19da terraform apply
   ```

## Troubleshooting

1. If an error occurs when applying the terraform it is possible that there is a cached version of an existing terraform set up. You can overcome this by deleting the ./infrastructure/environments/dev/.terraform/ folder and trying again.
