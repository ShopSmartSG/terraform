# resource "aws_lb_target_group" "traefik_tg" {
#   name        = "traefik-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_main_id
#   target_type = "ip" # Or "instance" based on your setup (typically "ip" for EKS)
#
#   # health_check {
#   #   path                = "/"
#   #   port                = "traffic-port"
#   #   protocol            = "HTTP"
#   #   matcher             = "200-399"
#   #   interval            = 30
#   #   timeout             = 5
#   #   healthy_threshold   = 2
#   #   unhealthy_threshold = 2
#   # }
#
#   tags = {
#     Name = "traefik-tg"
#   }
# }

resource "aws_lb_target_group" "traefik_tg_public" {
  name     = "traefik-tg-public"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_main_id
  target_type = "ip"

  # health_check {
  #   path                = "/"
  #   port                = "traffic-port"
  #   protocol            = "HTTP"
  #   matcher             = "200-399"
  #   interval            = 30
  #   timeout             = 5
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  # }
  tags = {
    Name = "traefik-tg_public"
  }
}

resource "aws_lb_target_group" "traefik_tg_private" {
  name     = "traefik-tg-private"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_main_id
  target_type = "ip"

  # health_check {
  #   path                = "/"
  #   port                = "traffic-port"
  #   protocol            = "HTTP"
  #   matcher             = "200-399"
  #   interval            = 30
  #   timeout             = 5
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  # }
  tags = {
    Name = "traefik-tg_private"
  }
}
