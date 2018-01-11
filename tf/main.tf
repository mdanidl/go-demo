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
    env   = "${var.app_env}"
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
      Name = "TEST_GOAPP_DM-${var.version}-${var.app_env}"
      Owner = "${lower(element(split("/",data.aws_caller_identity.current_user.arn),1))}"
  }
}

resource "aws_route53_record" "record-dev" {
  count   = "${var.app_env == "dev" ? 1 : 0}"
  zone_id = "ZJOMVAARB9FWK"
  name    = "dev.go"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.instance.public_ip}"]
}

resource "aws_route53_record" "record-uat" {
  count   = "${var.app_env == "uat" ? 1 : 0}"
  zone_id = "ZJOMVAARB9FWK"
  name    = "uat.go"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.instance.public_ip}"]
}


resource "aws_route53_record" "record-prod" {
  count   = "${var.app_env == "prod" ? 1 : 0}"
  zone_id = "ZJOMVAARB9FWK"
  name    = "go"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.instance.public_ip}"]
}