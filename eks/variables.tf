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

variable "vpc_main_id" {
  description = "AWS VPC Main Id"
  type = string
}
variable "vpc_main_cidr_block" {
  description = "AWS VPC Main CIDR Block"
  type = string
}

variable "iam_eks_cluster_policy_attachment" {
  description = "AWS IAM EKS Cluster policy attachment"
  type = string
}
variable "iam_eks_node_policy_attachment" {
  description = "AWS IAM EKS Node policy attachment"
  type = string
}
variable "iam_eks_cni_policy_attachment" {
  description = "AWS IAM EKS CNI policy attachment"
  type = string
}
variable "iam_eks_registry_policy_attachment" {
  description = "AWS IAM EKS Registry policy attachment"
  type = string
}

variable "eks_sg_id" {
  description = "EKS Security Group ID"
  type = string
}

variable "eks_nodes_sg_id" {
    description = "EKS Nodes Security Group ID"
    type = string
}

variable "nodegroup_config" {
  description = "Node group configurations"
  type        = list(object({
    name         = string
    ami_type     = string
    capacity_type = string
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
      ami_type      = "AL2_x86_64" ##CUSTOM
      capacity_type = "ON_DEMAND"
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
        "set" = "shopsmart-1",
        createdAt = "15/10/2025"
      }
    },
    {
      name          = "shopsmart2"
      ami_type      = "AL2_x86_64" ##CUSTOM
      capacity_type = "ON_DEMAND"
      instance_type = "t2.micro"
      desired_size  = 0
      min_size      = 0
      max_size      = 1
      labels        = {
        "ng_id" = "ss2",
        "shopsmart2" = "true"
      }
      tags = {
        "environment" = "dev",
        "set" = "shopsmart-2",
        createdAt = "15/10/2025"
      }
    }
  ]
}
