resource "aws_ssm_parameter" "acm_arn" {
  name  = "/${var.project}/${var.environment}/acm_arn"   
  type  = "StringList"
  value = aws_acm_certificate.dev84.arn 
}