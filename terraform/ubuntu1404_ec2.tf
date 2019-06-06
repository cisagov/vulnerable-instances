data "aws_ami" "metasploitable3_ubuntu1404" {
  filter {
    name = "name"

    values = [
      "metasploitable3-ubuntu-1404-hvm-*-x86_64-ebs",
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners      = [data.aws_caller_identity.current.account_id] # This is us
  most_recent = true
}

# The vulnerable Ubuntu 14.04 EC2 instance
resource "aws_instance" "vuln_ubuntu1404" {
  ami               = data.aws_ami.metasploitable3_ubuntu1404.id
  instance_type     = "t2.micro"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"

  subnet_id                   = aws_subnet.vuln_subnet.id
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.vuln_ubuntu1404_sg.id,
  ]

  user_data_base64 = data.template_cloudinit_config.ssh_cloud_init_tasks.rendered

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable Ubuntu 14.04"
    },
  )
  volume_tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable Ubuntu 14.04"
    },
  )
}
