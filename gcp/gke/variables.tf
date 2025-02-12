variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
}

variable "gcp_zone" {
  description = "GCP Zone"
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

variable "private_subnet_id" {
  description = "Private Subnet ID"
  type        = string
}

variable "ilb_proxy_subnet_id" {
  description = "ILB Proxy Subnet ID"
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
      name          = "shopsmart1"
      machine_type  = "e2-standard-4"
      min_count     = 1
      max_count     = 2
      desired_count = 1
      disk_size_gb  = 50
      tags          = ["general"]
      labels        = { "purpose" = "general", "ng_id" = "ss1", "service" = "true" }
    },
    {
      name          = "ss-elk"
      machine_type  = "e2-standard-4"
      min_count     = 1
      max_count     = 2
      desired_count = 1
      disk_size_gb  = 50
      tags          = ["general"]
      labels        = { "purpose" = "elk", "set" = "ss-elk" }
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


variable "public_endpoints" {
  description = "List of public services exposed via GCLB"
  type        = list(object({
    name       = string
    port       = number
  }))
  default = [
    {
      name       = "central-hub"
      port       = 82
    },
    {
      name       = "kibana"
      port       = 5601
    }
  ]
}

variable "private_endpoints" {
  description = "List of private services using ILB"
  type        = list(object({
    name       = string
    port       = number
  }))
  default = [
    {
      name       = "central-hub"
      port       = 82
    },
    {
      name       = "kibana"
      port       = 5601
    },
    {
      name       = "profile-service"
      port       = 80
    },
    # {
    #   name       = "product-service"
    #   port       = 95
    # },
    {
      name       = "order-service"
      port       = 85
    }
    # {
    #   name       = "delivery-service"
    #   port       = 92
    # },
    # {
    #   name       = "login-service"
    #   port       = 98
    # },
    # {
    #   name       = "utility-service"
    #   port       = 90
    # }
  ]
}

variable "ss_postgres_sa_email" {
    description = "Service Account Email for Cloud SQL"
    type        = string
}