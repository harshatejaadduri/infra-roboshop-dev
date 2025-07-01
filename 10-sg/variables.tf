variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
    default = "frontend"
}

variable "frontend_sg_description" {
    default = "created sg for frontend instance"
}

variable "bastion_sg_name" {
    default = "bastion"
}

variable "bastion_sg_description" {
    default = "created sg for bastion instance"
}

variable "vpn_port" {
  default = [22,443,1194,943]
}

variable "mongodb_port" {
  default = [22,27017]
}

variable "redis_port" {
  default = [22,6379]
}

variable "mysql_port" {
  default = [22,3306]
}

variable "rabbitmq_port" {
  default = [22,5672]
}

variable "catalogue_sg_name" {
  default = "catalogue"
}