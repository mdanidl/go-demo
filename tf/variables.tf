variable "aws_region" {
    default = "eu-west-1"
}
variable "aws_subnet_id" {}
variable "security_group_ids" {
    default = []
}
variable "key_name" {}
variable "instance_type" { 
    default = "t2.small"
 }
 variable "version" {}
 variable "app_env" {
     default = "dev"
 }