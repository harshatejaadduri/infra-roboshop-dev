resource "aws_instance" "vpn" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id = local.public_subnet_id
  key_name = "openvpn"
  user_data = file("openvpn.sh")

  tags = merge( local.common_tags, {
    Name = "${var.project}-${var.environment}-vpn"
  }
  )
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "vpn.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.vpn.public_ip]
}