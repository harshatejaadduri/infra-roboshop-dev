resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id = local.public_subnet_id
  iam_instance_profile = "TerrafromEc2Access"
  
  
  tags = merge( local.common_tags, {
    Name = "${var.project}-${var.environment}-bastion"
  }
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
   aws_instance.bastion.id
  ]
   provisioner "local-exec" {
   command = "sudo dnf install ansible -y | git clone https://github.com/harshatejaadduri/infra-roboshop-dev.git" 
  }
  depends_on = [ aws_instance.bastion ]
}