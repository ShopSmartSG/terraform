resource "aws_launch_template" "eks_launch_template" {
  name          = "eks-node-launch-template"
  image_id      = "ami-0ad522a4a529e7aa8"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "EKS Node"
      createdBy = "terraform"
    }
  }
}
