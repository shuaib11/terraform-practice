terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

#Create an S3 Bucket:
resource "aws_s3_bucket" "mybucket" {
  bucket = "my-test-bucket"
  acl    = "private"
  #region = "____"  You can specify region here

  tags = {
    Name        = "My bucket 1"
    Environment = "Dev"
  }
}

#Upload file to S3 Bucket:
#Google: terraform aws s3 object
resource "aws_s3_bucket_object" "my-first-object" {
  bucket = "${aws_s3_bucket.mybucket.id}"
  key    = "testfile.txt"
  source = "path/to/file"
  etag = filemd5("path/to/file")
}

#Launch EC2 instance:

#1.Create key pair
#Google: aws terraform key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

#2.Create security group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id   #OR: vpc_id = "${var.vpcid}" -> But for this you must create a variable i.e:
                                   #   variable "vpcid" {
                                   #     type = "string"
                                   #     default = ""
                                   #    }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#3.Launch instance
#Google: terraform aws instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = "value"
  vpc_security_group_ids = [ "value" ]

  tags = {
    Name = "HelloWorld"
  }
}