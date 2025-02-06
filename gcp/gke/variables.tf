variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "private_subnet_name" {
  description = "Private Subnet Name"
  type        = string
}

variable "node_pools" {
  description = "List of node pools configurations"
  type = list(object({
    name          = string
    machine_type  = string
    min_count     = number
    max_count     = number
    desired_count = number
    disk_size_gb  = number
    tags          = list(string)
    labels        = map(string)
  }))
  default = [
    {
      name          = "general-pool"
      machine_type  = "e2-standard-4"
      min_count     = 1
      max_count     = 2
      desired_count = 1
      disk_size_gb  = 50
      tags          = ["general"]
      labels        = { "purpose" = "general", "ng_id" = "ss1" }
    },
    {
      name          = "compute-pool"
      machine_type  = "e2-highcpu-8"
      min_count     = 0
      max_count     = 0
      desired_count = 0
      disk_size_gb  = 100
      tags          = ["compute"]
      labels        = { "purpose" = "compute", "ng_id" = "ss2" }
    }
  ]
}

variable "gke_sa_email" {
  description = "GKE Service Account Email"
  type        = string
}

variable "gke_node_sa_name" {
    description = "GKE Node Service Account Name"
    type        = string
}
