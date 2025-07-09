module "components" {
  for_each = var.components
  source = "git::https://github.com/harshatejaadduri/terraform-aws-roboshop.git?ref=main"
  component = each.key
  priority_rule = each.value.priority_rule
}