module "alb" {
  source = "terraform-aws-modules/alb/aws"
   internal = true
  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_id
  enable_deletion_protection = false
  create_security_group = false #as we are creating as our own sg for alb
  security_groups = [local.alb_sg_id]

  tags = merge( local.common_tags, {
    Name = "${var.project}-${var.environment}-alb"
  }
  )
}

resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I'm From backend ALB<h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-dev.${var.domain_name}"
  type    = "A"

  alias { 
    name                   = module.alb.dns_name #alb zone name
    zone_id                = module.alb.zone_id  #alb zone id 
    evaluate_target_health = true
  }
}