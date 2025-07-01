module "frontend_sg" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id = local.vpc_id
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

module "vpn" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "vpn"
  sg_description = "sg for vpn"
  vpc_id = local.vpc_id
}

#vpn port nos 22,443,1194,943

resource "aws_security_group_rule" "vpn_943" {
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
  cidr_blocks = [ "0.0.0.0/0" ]  #sourcing sg id to bastion sg id instead of giving ip address
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
  cidr_blocks = [ "0.0.0.0/0" ]  
  security_group_id =  module.redis.sg_id 
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
  cidr_blocks = [ "0.0.0.0/0" ] 
  security_group_id =  module.mysql.sg_id 
}

module "rabbitmq" {
  source = "git::https://github.com/harshatejaadduri/terraform-sg.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "rabbitmq"
  sg_description = "sg for rabbitmq"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "rabbitmq_sg_rules" {
  count = length(var.rabbitmq_port)
  type              = "ingress"
  from_port         = var.rabbitmq_port[count.index]
  to_port           = var.rabbitmq_port[count.index]
  protocol          = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]  
  security_group_id =  module.rabbitmq.sg_id 
}

