# data "aws_subnet" "public_subnets" {
#   ids = var.public_subnet_ids
# }
#
# data "aws_subnet" "private_subnets" {
#   id = var.private_subnet_ids
# }

# data "aws_iam_role" "eks_cluster_iam_role" {
#   arn = var.eks_cluster_role_arn
#   name = var.eks_cluster_role_name
# }

# data "aws_iam_role" "eks_node_iam_role" {
#   arn = var.eks_node_role_arn
#   name = var.eks_node_role_name
# }

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = concat(
      var.public_subnet_ids,
      var.private_subnet_ids
    )
  }

  version = "1.29"

  tags = {
    Name = var.cluster_name
  }
}
