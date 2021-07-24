#PROVIDER
provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#RESOURCES

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"
  region = var.region
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Name = "created-by-terraform"
  }
}

#EC2
module "ec2-instance" {
  instance_count = 2
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"
  ami = data.aws_ssm_parameter.linux.value
  instance_type = "t2.micro"
  vpc_security_group_ids = module.vpc.default_security_group_id
  subnet_ids = module.vpc.public_subnets
  associate_public_ip_address = true
  Name = "public-ec2"
}

module "ec2-instance" {
  instance_count = 2
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"
  ami = data.aws_ssm_parameter.linux.value
  instance_type = "t2.micro"
  vpc_security_group_ids = module.vpc.default_security_group_id
  subnet_ids = module.vpc.private_subnets[0]
  Name = "private-ec2"
}
