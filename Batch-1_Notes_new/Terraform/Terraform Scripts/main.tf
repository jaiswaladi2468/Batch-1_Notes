provider "aws" {
region = "us-east-1"

access_key= "AKIA4SVX7YEJAFK7RCCZ"
secret_key= "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"
}


resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"

tags = {
    Name = "vpc-1"
  }
}

resource "aws_vpc" "vpc-2" {
  cidr_block = "10.1.0.0/16"

tags = {
    Name = "vpc-2"
  }
}


resource "aws_subnet" "sub-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"

tags = {
    Name = "sub-1"
  }

}


resource "aws_subnet" "sub-2" {
  vpc_id     = aws_vpc.vpc-2.id
  cidr_block = "10.1.0.0/16"

tags = {
    Name = "sub-2"
  }

}

resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_id}"
    count = "${var.number_of_instances}"
    subnet_id = "${var.subnet_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.ami_key_pair_name}"

        tags = {
    Name = "${var.resource_tags}"
  }
}

output "my_vpc_output" {
value = aws_vpc.vpc-1.id
}

output "my_subnet_output" {
value = aws_subnet.sub-1.id
}
