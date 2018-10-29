variable "vpc_name"  {
    description = "Name of VPC to be used with tagging"
    default = ""
}

variable "stack_name" {
    description = "Application Stack to be deployed"
    default = ""
}

variable "vpc_cidr" {
    description = "Main VPC to be created"
    default = ""
}

variable "untrust_subnets" {
    description = "List of untrusted subnets to create"
    default = []
}

variable "trust_subnets" {
    description = "List of Trusted Subnets to Create"
    default = []
}

variable "availability_zones" {
    description = "List of Availability zones"
    default = []
}

variable "customer_asns" {
    description = "List of ASNs Customer has provided"
    default = []
}

variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

data "aws_availability_zones" "default" {
}
/* #Variables needed for Autoscaling#
variable "NATGWSubnetIpBlocks" {
  default = ["192.168.100.0/24", "192.168.101.0/24",
              "192.168.102.0/24", "192.168.103.0/24"]
}

variable "LambdaSubnetIpBlocks" {
  type = "list"
  default = ["192.168.200.0/24", "192.168.201.0/24",
              "192.168.202.0/24", "192.168.203.0/24"]
}

variable "NATGateway" {
  description = "1 = create AWS NAT Gateway in each AZ, 0 = Use EIPs (skip subnet CIDR for NAT/Lambda)"
}
variable "AWSInstanceType2Arch" {
  type = "map"
  default = {
    "t1.micro"    = "PV64"
    "t2.micro"    = "HVM64"
    "t2.small"    = "HVM64"
    "t2.medium"   = "HVM64"
    "m1.small"    = "PV64"
    "m1.medium"   = "PV64"
    "m1.large"    = "PV64"
    "m1.xlarge"   = "PV64"
    "m2.xlarge"   = "PV64"
    "m2.2xlarge"  = "PV64"
    "m2.4xlarge"  = "PV64"
    "m3.medium"   = "HVM64"
    "m3.large"    = "HVM64"
    "m3.xlarge"   = "HVM64"
    "m3.2xlarge"  = "HVM64"
    "c1.medium"   = "PV64"
    "c1.xlarge"   = "PV64"
    "c3.large"    = "HVM64"
    "c3.xlarge"   = "HVM64"
    "c3.2xlarge"  = "HVM64"
    "c3.4xlarge"  = "HVM64"
    "c3.8xlarge"  = "HVM64"
    "c4.large"    = "HVM64"
    "c4.xlarge"   = "HVM64"
    "c4.2xlarge"  = "HVM64"
    "c4.4xlarge"  = "HVM64"
    "c4.8xlarge"  = "HVM64"
    "g2.2xlarge"  = "HVMG2"
    "r3.large"    = "HVM64"
    "r3.xlarge"   = "HVM64"
    "r3.2xlarge"  = "HVM64"
    "r3.4xlarge"  = "HVM64"
    "r3.8xlarge"  = "HVM64"
    "i2.xlarge"   = "HVM64"
    "i2.2xlarge"  = "HVM64"
    "i2.4xlarge"  = "HVM64"
    "i2.8xlarge"  = "HVM64"
    "d2.xlarge"   = "HVM64"
    "d2.2xlarge"  = "HVM64"
    "d2.4xlarge"  = "HVM64"
    "d2.8xlarge"  = "HVM64"
    "hi1.4xlarge" = "HVM64"
    "hs1.8xlarge" = "HVM64"
    "cr1.8xlarge" = "HVM64"
    "cc2.8xlarge" = "HVM64"
  }
}
variable "BucketRegionMap" {
  type = "map"
  default =
    {
      "us-west-2" = "panw-aws-us-west-2"
      "us-west-1" = "panw-aws-us-west-1"
      "us-east-1" = "panw-aws-us-east-1"
      "us-east-2" = "panw-aws-us-east-2"
      "eu-west-1" = "panw-aws-eu-west-1"
      "eu-central-1"  = "panw-aws-eu-central-1"
      "ap-northeast-1" = "panw-aws-ap-northeast-1"
      "ap-northeast-2" = "panw-aws-ap-northeast-2"
      "ap-southeast-1" = "panw-aws-ap-southeast-1"
      "ap-southeast-2" = "panw-aws-ap-southeast-2"
      "sa-east-1" = "panw-aws-sa-east-1"
    }
}

#variable "WebServerImageId" {}
/*