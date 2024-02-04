provider "aws" {
  region = "us-east-1" # You can change this to your preferred AWS region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}


# Find the default VPC
data "aws_vpc" "default" {
  default = true
}

# Find a public subnet of the default VPC
data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"] # Replace with the desired availability zone
  }
}

# Find a public subnet of the default VPC
data "aws_subnet" "default2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1b"] # Replace with the desired availability zone
  }
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = "key"
  public_key = file("key.pub")
}

module "SG" {
  source = "./modules/SG"
  vpc_id = data.aws_vpc.default.id
}

module "EC2" {
  source          = "./modules/EC2"
  security_groups = [module.SG.web_sg_id]
  key_name        = aws_key_pair.web_key.key_name
  aws_subnet_id   = data.aws_subnet.default.id

}


module "ALB" {
  source          = "./modules/ALB"
  security_groups = [module.SG.web_sg_id]
  vpc_id          = data.aws_vpc.default.id
  instance_id     = module.EC2.instance_id
  aws_subnet_id   = data.aws_subnet.default.id
  aws_subnet_id_2 = data.aws_subnet.default2.id

}

module "ECR" {
  source = "./modules/ECR"
}




