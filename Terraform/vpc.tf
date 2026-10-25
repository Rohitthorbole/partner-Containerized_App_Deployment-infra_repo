//Using a very own of mine module, created in past, to create a VPC with CIDR
//happy that I am able to use my own modules now, 
module "vpc" {
  source = "git::https://github.com/Rohitthorbole/partner-devops-project02.git//terraform/modules/vpc?ref=v1.1"

  //VPC 
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "my-vpc"

  //Subnets
  create_private_subnet = true
  private_subnet_cidr = ({
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  })

  create_nat_gateway = true
}