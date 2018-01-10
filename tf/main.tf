data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = "${file("scripts/user_data.sh")}"

  vars {
    v_num = "${var.version}"
    v_col = "${var.version_colour}"
  }
}

resource "aws_instance" "instance" {
  ami                       = "${data.aws_ami.ubuntu.id}"
  subnet_id                 = "${var.aws_subnet_id}"
  instance_type             = "${var.instance_type}"
  key_name                  = "${var.key_name}"
  vpc_security_group_ids    = "${var.security_group_ids}"
  user_data                 = "${data.template_file.user_data.rendered}"
  
  tags {
      Name = "TEST_GOAPP_DM"
      Owner = "${lower(element(split("/",data.aws_caller_identity.current_user.arn),1))}"
  }
}
