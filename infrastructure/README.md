# Infrastructure

We use [Terraform](https://www.terraform.io/) to build our environments.

## Installation Instructions

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

## Development Environment Setup

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

1. Follow the onscreen instructions to create the terraform.tfvars file.

   The contents of the file should still be printed on the screen.

   Below is an example of what it would likely look like:

   ```hcl-terraform
   resource_group_name="tfstatejohn"
   storage_account_name="fnhstfstatedevjohn"
   USERNAME="john"
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

1. To reduce infrastructure costs for the NHS, please destroy your environment when you no longer need it.

   ```bash
   terraform destroy
   ```

## Troubleshooting

1. If an error occurs when applying the terroform it is possible that there is a cached version of an existing terraform set up. You can overcome this by deleting the ./infrastructure/environments/dev/ folder and trying again.
