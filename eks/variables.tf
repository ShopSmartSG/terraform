variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "shopsmart-eks-cluster"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type = list(string)
}

variable "eks_cluster_role_arn" {
  description = "ARN of EKS cluster IAM role"
  type = string
}

variable "eks_cluster_role_name" {
  description = "Name of EKS cluster IAM role"
  type = string
}

variable "eks_node_role_arn" {
  description = "ARN of EKS Node IAM role"
  type = string
}

variable "eks_node_role_name" {
  description = "Name of EKS Node IAM role"
  type = string
}

variable "nodegroup_config" {
  description = "Node group configurations"
  type        = list(object({
    name         = string
    ami_type     = string
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
    labels        = map(string)
    tags          = map(string)
  }))
  default = [
    {
      name          = "shopsmart1"
      ami_type      = "AL2_x86_64"
      instance_type = "t2.micro"
      desired_size  = 1
      min_size      = 1
      max_size      = 1
      labels        = {
        "ng_id" = "ss1",
        "shopsmart1" = "true"
      }
      tags = {
        "environment" = "dev",
        "set" = "shopsmart-1"
      }
    },
    {
      name          = "shopsmart2"
      ami_type      = "AL2_x86_64"
      instance_type = "t2.micro"
      desired_size  = 1
      min_size      = 1
      max_size      = 1
      labels        = {
        "ng_id" = "ss2",
        "shopsmart2" = "true"
      }
      tags = {
        "environment" = "dev",
        "set" = "shopsmart-2"
      }
    }
  ]
}
