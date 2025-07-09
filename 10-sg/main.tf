module "mongodb" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "mongodb"
  sg_description = "sg for mongodb"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "mongodb_sg_rules" {
  count = length(var.mongodb_port)
  type              = "ingress"
  from_port         = var.mongodb_port[count.index]
  to_port           = var.mongodb_port[count.index]
  protocol          = "tcp"
 source_security_group_id = module.vpn.sg_id
  security_group_id =  module.mongodb.sg_id 
}

resource "aws_security_group_rule" "mongodb_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.mongodb.sg_id 
}

module "redis" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "redis"
  sg_description = "sg for redis"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "redis_sg_rules" {
  count = length(var.redis_port)
  type              = "ingress"
  from_port         = var.redis_port[count.index]
  to_port           = var.redis_port[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.redis.sg_id 
}

resource "aws_security_group_rule" "redis_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.redis.sg_id 
}

module "rabbitmq" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "rabbitmq"
  sg_description = "sg for rabbitmq"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "rabbitmq_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.rabbitmq.sg_id 
}

resource "aws_security_group_rule" "rabbitmq_sg_rules" {
  count = length(var.rabbitmq_port)
  type              = "ingress"
  from_port         = var.rabbitmq_port[count.index]
  to_port           = var.rabbitmq_port[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.rabbitmq.sg_id 
}

module "mysql" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "mysql"
  sg_description = "sg for mysql"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "mysql_sg_rules" {
  count = length(var.mysql_port)
  type              = "ingress"
  from_port         = var.mysql_port[count.index]
  to_port           = var.mysql_port[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.mysql.sg_id 
}

resource "aws_security_group_rule" "mysql_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.mysql.sg_id 
}

module "bastion_sg" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "bastion_local" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

#for backend alb 

module "alb" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "alb"
  sg_description = "sg for alb"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "alb_sg_rules" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to bastion sg id instead of giving ip address
  security_group_id =  module.alb.sg_id 
}

#for vpn and connecting port nos 22,443,1194,943

module "vpn" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "vpn"
  sg_description = "sg for vpn"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "vpn_ports" {
  count = length(var.vpn_port)
  type              = "ingress"
  from_port         = var.vpn_port[count.index]
  to_port           = var.vpn_port[count.index]
  protocol          = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id =  module.vpn.sg_id 
}

resource "aws_security_group_rule" "vpn_alb_sg_rules" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  #sourcing sg id to bastion sg id instead of giving ip address
  security_group_id =  module.alb.sg_id 
}

#for catalogue 

module "catalogue" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.catalogue_sg_name
  sg_description = "for catalogue "
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "catalogue_sg_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.alb.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.catalogue.sg_id 
}

resource "aws_security_group_rule" "catalogue_vpn_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  #sourcing vpn sg id to catalogue  
  security_group_id =  module.catalogue.sg_id 
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.catalogue.sg_id 
}

resource "aws_security_group_rule" "catalogue_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.catalogue.sg_id 
}

resource "aws_security_group_rule" "catalogue_mongodb_sg" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id  #sourcing sg id to catalogue  
  security_group_id =   module.mongodb.sg_id
}

#sg and rules for user

module "user" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "user"
  sg_description = "sg for user"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "user_sg_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.user.sg_id 
}

resource "aws_security_group_rule" "user_sg_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.user.sg_id 
}

resource "aws_security_group_rule" "user_sg_redis" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id =  module.redis.sg_id 
}

resource "aws_security_group_rule" "user_sg_mongodb" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id =  module.mongodb.sg_id 
}

resource "aws_security_group_rule" "user_sg_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.alb.sg_id
  security_group_id =  module.user.sg_id 
}

resource "aws_security_group_rule" "user_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.user.sg_id 
}
#sg and rules for cart

module "cart" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "cart"
  sg_description = "sg for cart"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "cart_sg_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.cart.sg_id 
}

resource "aws_security_group_rule" "cart_sg_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.cart.sg_id 
}

resource "aws_security_group_rule" "cart_sg_redis" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id =  module.redis.sg_id 
}

resource "aws_security_group_rule" "backend_alb_sg_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id =  module.alb.sg_id 
}

resource "aws_security_group_rule" "cart_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.cart.sg_id 
}

resource "aws_security_group_rule" "cart_sg_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.alb.sg_id
  security_group_id =  module.cart.sg_id 
}

#sg and rules for shipping

module "shipping" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "shipping"
  sg_description = "sg for shipping"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "shipping_sg_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.shipping.sg_id 
}

resource "aws_security_group_rule" "shipping_sg_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.shipping.sg_id 
}

resource "aws_security_group_rule" "shipping_sg_mysql" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id =  module.mysql.sg_id 
}

resource "aws_security_group_rule" "backend_alb_sg_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id =  module.alb.sg_id 
}

resource "aws_security_group_rule" "shipping_sg_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.alb.sg_id
  security_group_id =  module.shipping.sg_id 
}

resource "aws_security_group_rule" "shipping_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.shipping.sg_id 
}

#sg and rules for payment

module "payment" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "payment"
  sg_description = "sg for payment"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "payment_sg_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.payment.sg_id 
}

resource "aws_security_group_rule" "payment_sg_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.payment.sg_id 
}

resource "aws_security_group_rule" "payment_sg_rabbitmq" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id =  module.rabbitmq.sg_id 
}

resource "aws_security_group_rule" "backend_alb_sg_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id =  module.alb.sg_id 
}

resource "aws_security_group_rule" "payment_sg_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.alb.sg_id
  security_group_id =  module.payment.sg_id  
}

resource "aws_security_group_rule" "payment_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.payment.sg_id 
}

# for frontend

module "frontend" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "frontend_sg_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id =  module.frontend.sg_id 
}

resource "aws_security_group_rule" "frontend_sg_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id =  module.frontend.sg_id 
}

resource "aws_security_group_rule" "frontend_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id  #sourcing sg id to catalogue  
  security_group_id =  module.frontend.sg_id 
}

resource "aws_security_group_rule" "backend_alb_sg_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id =  module.alb.sg_id 
}

# for frontend alb

module "frontend_alb" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "frontend-alb"
  sg_description = "sg for frontend-alb"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "frontend_alb_sg_rules" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id =  module.frontend_alb.sg_id 
}
