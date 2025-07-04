resource "aws_ssm_parameter" "backend_alb_listner_arn" {
 name  = "/${var.project}/${var.environment}/backend_alb_listner_arn"   
  type  = "StringList"
  value =  aws_lb_listener.backend_alb.arn
}