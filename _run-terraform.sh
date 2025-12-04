#!/bin/sh

# Script to run terraform modules 
# Usage :
# - ./script.sh


# Stop script if missing dependency
required_commands="terraform"
for command in $required_commands; do
	if [ -z "$(command -v $command)" ]; then
		echo "error: required command not found: \e[91m$command\e[97m"
        exit
	fi
done


# Get value of a variable declared in a given file from this pattern: variable = value
# Usage: get_var_value <file> <variable>
get_var_value() {
    local file=$1
    local variable=$2

    cat $file | grep '=' | grep -w $variable | sed 's|.*"\(.*\)".*|\1|' | head -n 1
}

tenant_name="$(get_var_value terraform.tfvars tenant)"
webapp_name="$(get_var_value terraform.tfvars webapp_name)"
state_file_name="tfstate-tenant-$tenant_name-webapp-$webapp_name"
cloud_provider="$(get_var_value terraform.tfvars cloud_provider)"

# Clear old data
rm -rf .terraform*
rm -rf terraform.tfstate*


# The trick here is to write configuration in a dynamic file created at the begin of the
# execution, containing the config that the concerned provider is waiting for Terraform backend.
# Then, Terraform will automatically detects it from its .tf extension.
backend_file="backend.tf"
case "$(echo $cloud_provider)" in
  'azure')
    state_storage_name='"cosmotechstates"'
    echo " \
        terraform {
            backend \"azurerm\" {
              resource_group_name    = $state_storage_name
              storage_account_name   = $state_storage_name
              container_name         = $state_storage_name
              key                    = \"$state_file_name\"
            }
        }

        provider \"azurerm\" {
          features {}
          subscription_id = var.azure_subscription_id
          tenant_id       = var.azure_entra_tenant_id
        }

        variable \"azure_subscription_id\" { type = string }
        variable \"azure_entra_tenant_id\" { type = string }
    " > $backend_file ;;
  *)
    echo "error: unknown or empty \e[91mcloud_provider\e[0m from terraform.tfvars"
    exit
    ;;
esac


# Deploy
terraform fmt -recursive $backend_file
terraform init -upgrade -reconfigure   
terraform plan -out .terraform.plan
terraform apply .terraform.plan


exit