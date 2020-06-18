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

## Development Environment

Infrastructure is set up so that each developer can create their own instance of the environment in Azure,
as opposed to sharing a staging environment.

1. Clone the FutureNHS Platform.

1. Create the new dev environment with **your name** as the parameter.

   If your name is **John**, your command is as follows:

   ```bash
   ./infrastructure/scripts/create-dev-environment.sh john
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

   As with step 2, if your name is **John**, your command will be:

   ```bash
   az aks update -n dev-john -g platform-dev-john --attach-acr "/subscriptions/75173371-c161-447a-9731-f042213a19da/resourceGroups/platform-production/providers/Microsoft.ContainerRegistry/registries/fnhsproduction"
   ```

1. In order to use Kubernetes CLI (kubectl) commands, you need to pull the credentials from the server.

   As with step 2, if your name is **John**, your command will be:

   ```bash
   az aks get-credentials --resource-group platform-dev-john --name dev-john
   ```

1. To install the [Linkerd](https://linkerd.io/) control plane, run the `install-linkerd.sh` script that can be found within `infrastructure/scripts` directory.

   ```bash
   ./install-linkerd.sh
   ```

   Once installed, view the Linkerd dashboard with the following command:

   ```bash
   linkerd dashboard &
   ```

1. install Argo CD [ArgoCD](https://argoproj.github.io/argo-cd/) (insert instructions here with a script) run the `install-argo-cd.sh` script that can be found within `infrastructure/scripts` directory.

   ```bash
   ./install-argo-cd.sh
   ```

   ```bash
   ./configure-argo-cd.sh
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

1. To reduce infrastructure costs for the NHS, please destroy your environment when you no longer need it.

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

1. If an error occurs when applying the terroform it is possible that there is a cached version of an existing terraform set up. You can overcome this by deleting the ./infrastructure/environments/dev/.terraform/ folder and trying again.
