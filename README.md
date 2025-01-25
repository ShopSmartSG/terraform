# Different ways to use terraform
## Normal way (1 provider 1 env)
directly use the following : 
1. `terraform init`
2. `terraform plan`
3. `terraform apply`
4. (or including the var region) `terraform apply -var="aws_region=us-west-1"`

## Multi provider and 1 env
here need to keep each provider in their own folder and then use the following :
1. `terraform -chdir={provider} init`
2. `terraform -chdir={provider} plan`
3. `terraform -chdir={provider} apply`

## Multi provider and multi env
here need to keep each provider in their own folder 
and inside each provider we can maintain different env folders like dev or prod.
In every env folder need to maintain required files like main or backend (to maintain state file) or variables.
Any shared configs can be maintained in the "shared" folder inside the provider.
Then use the following :
1. `terraform -chdir={provider}/{env} init`
2. `terraform -chdir={provider}/{env} plan`
3. `terraform -chdir={provider}/{env} apply`


## In case of switching styles of heirarchy
First always run
`init` with either `-migrate-state` or `-reconfigure` flag


## Concept of workspaces
### What Does terraform workspace Do?
The terraform workspace command allows you to create and manage multiple state files within the same backend configuration. 
Each workspace is essentially a separate state file, making it useful for managing multiple environments (e.g., dev, staging, prod) 
without needing to change your code or backend configuration.

By default, Terraform operates in the default workspace.
When you switch workspaces (e.g., terraform workspace new dev), Terraform uses a different state file path in your backend.
For example, if you use AWS S3 as a backend, the state files might be stored like this:

default: `s3://bucket-name/path-to-state/default/terraform.tfstate`
dev: `s3://bucket-name/path-to-state/dev/terraform.tfstate`
prod: `s3://bucket-name/path-to-state/prod/terraform.tfstate`
This is helpful for isolating resources by environment without needing separate backend configurations.

### How -chdir Differs
The -chdir flag tells Terraform to run commands from a specific directory. This is useful when:

You have separate directories for AWS and GCP (as in your case).
You want to execute Terraform commands scoped to a specific directory without navigating there manually.
Example:
`terraform -chdir=aws init`
`terraform -chdir=aws plan`
`terraform -chdir=aws apply`
With -chdir, Terraform still uses the same workspace (e.g., `default`) unless you explicitly switch it.

### Why Use Workspaces with -chdir?
If you’re already using -chdir to separate directories for AWS and GCP, you might not need terraform workspace 
unless you want to manage multiple environments within the same directory (e.g., aws/dev vs. aws/prod).
For example:
If you're using aws/ for all AWS resources and want to create isolated state files for dev, staging, and prod, workspaces would be helpful:
`terraform -chdir=aws workspace new dev`
`terraform -chdir=aws workspace select dev`
`terraform -chdir=aws plan`
`terraform -chdir=aws apply`

However, if you’re separating environments by directories (e.g., aws/dev, aws/prod), you might not need workspaces. 
You can use -chdir to work with specific directories:
`terraform -chdir=aws/dev init`
`terraform -chdir=aws/dev plan`
`terraform -chdir=aws/dev apply`

### More info on how to exactly use workspaces
#### High-Level Folder/File Structure
terraform/
├── main.tf        # Shared resources
├── variables.tf   # Shared variables with workspace-based overrides
├── outputs.tf     # Shared outputs
├── backend.tf     # Backend configuration
├── locals.tf      # Dynamically set variables based on workspace
├── modules/       # Shared modules (e.g., VPC, EKS, IAM roles)

#### 1. Configuration Details
Backend Configuration (backend.tf)
```
terraform {
    backend "s3" {
        bucket         = "shopsmart-terraform-state"
        key            = "terraform/${terraform.workspace}/terraform.tfstate" # Separate state files per workspace
        region         = "ap-southeast-1"
        dynamodb_table = "terraform-state-lock"
    }
}
```
The ${terraform.workspace} ensures separate state files for each workspace.

#### 2. Dynamic Environment Configuration (locals.tf)
Use terraform.workspace to set values dynamically.
```
locals {
    environment = terraform.workspace
    
    node_group_config = {
        dev = {
            desired_size  = 2
            instance_type = "t2.micro"
        }
        prod = {
            desired_size  = 4
            instance_type = "t3.medium"
        }
    }
}
```

#### 3. Shared Resources (main.tf)
Reference locals to configure resources dynamically.
```
module "vpc" {
    source = "./modules/vpc"
}
    
module "eks_node_group" {
    source         = "./modules/eks_node_group"
    node_group_name = "${local.environment}-node-group"
    desired_size    = local.node_group_config[local.environment].desired_size
    instance_type   = local.node_group_config[local.environment].instance_type
}
```

#### 4. Variables (variables.tf)
Define shared variables.
```
variable "region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "ap-southeast-1"
}
```

### Managing Workspaces
#### Create Workspaces

```
terraform workspace new dev   # Create a workspace for dev
terraform workspace new prod  # Create a workspace for prod
```

#### Select Workspace
```
terraform workspace select dev  # Switch to dev
terraform workspace select prod # Switch to prod
```

#### Run Commands
For dev:
```
terraform init
terraform plan
terraform apply
```
For prod:
```
terraform init
terraform plan
terraform apply
```

### Advantages
1. Single Configuration: No duplication of code or directories. 
2. Dynamic Adjustments: Easily manage differences between environments (e.g., `dev` and `prod`). 
3. Scalable: Add new environments by simply creating a workspace and updating the `locals.tf` configuration.

### Note
1. Ensure all environment-specific configurations are driven by `terraform.workspace` or variables based on `local.environment`. 
2. The backend configuration must use `${terraform.workspace}` to avoid overwriting state files.
3. If unsure always avoid using this :D 
