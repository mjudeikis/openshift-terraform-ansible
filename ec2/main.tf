variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "security_group" {default = "sg-7e73221a"}
variable "keypair" {default = "osekeypair"}
variable "master_instance_type" {default = "c3.large"}
variable "node_instance_type" {default = "c3.large"}
variable "aws_availability_zone" {default = "us-east-1"}
variable "aws_region" {default = "us-east-1"}
variable "ebs_root_block_size" {default = "50"}
variable "aws_ami" {default = "ami-12663b7a"}
variable "num_nodes" { default = "2" }
variable "prefix" { default = "ose_" }
variable "vpc_group_id" { default = "sg-7e73221a"}
variable "subnet_id" { default = "subnet-cf57c596" }
variable "postfix" { default = "-preserve"}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_instance" "ose-master" {
    ami = "${var.aws_ami}"
    instance_type = "${var.master_instance_type}"
    #security_groups = [ "default", "${var.security_group}" ]
    availability_zone = "${var.aws_availability_zone}"
    vpc_security_group_ids = ["${var.vpc_group_id}"]
    subnet_id = "${var.subnet_id}"
    key_name = "${var.keypair}"
    tags {
        Name = "${var.prefix}master${var.postfix}"
        sshUser = "root"
        role = "masters"
    }
	root_block_device = {
		volume_type = "gp2"
		volume_size = "${var.ebs_root_block_size}"
	}
    ebs_block_device {
        device_name = "/dev/xvdc"
        volume_type = "gp2"
        volume_size = 100
     }
}

resource "aws_instance" "ose-node" {
    count = "${var.num_nodes}"
    ami = "${var.aws_ami}"
    instance_type = "${var.node_instance_type}"
   # security_groups = [ "default", "${var.security_group}" ]
    availability_zone = "${var.aws_availability_zone}"
    vpc_security_group_ids = ["${var.vpc_group_id}"]
    subnet_id = "${var.subnet_id}"
    key_name = "${var.keypair}"
    tags {
        Name = "${var.prefix}node${count.index}${var.postfix}"
        sshUser = "root"
        role = "nodes"
    }
	root_block_device = {
		volume_type = "gp2"
		volume_size = "${var.ebs_root_block_size}"
	}
    ebs_block_device {
        device_name = "/dev/xvdc"
        volume_type = "gp2"
        volume_size = 100
    }
}

output "masters" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = ["${aws_instance.ose-master.*.public_dns}","${aws_instance.ose-node.*.public_ip}"]
}

output "nodes" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = ["${aws_instance.ose-node.*.public_dns}","${aws_instance.ose-node.*.public_ip}" ]
}
