resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id = local.public_subnet_id
  iam_instance_profile = "TerrafromEc2Access"
  
  root_block_device{
    volume_size = 50
    volume_type = "gp3"
  }
  
  tags = merge( local.common_tags, {
    Name = "${var.project}-${var.environment}-bastion"
  }
  )
}

resource "terraform_data" "bastion" {
  triggers_replace = [
   aws_instance.bastion.id
  ]
   provisioner "file" {            
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }
   connection {                   
    type     = var.type
    user     = var.user
    password = var.password
    host     = aws_instance.bastion.public_ip
  }
   provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sh /tmp/install.sh"
    ]
  }
}
