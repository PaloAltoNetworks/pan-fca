# Firewall Deployment Variables
variable "availability_zones" {
    description = "List of Availability zones"
    default = []
}
variable "aws_region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "count" {
    description = "count variable"
    default = ""
}

#Application Stackname
variable "StackName" {
  default = ""
}

#Main Stackname
variable "MainStackName" {
  default = "Main-Transit"
}

# select the key for auth
variable "serverkey" {}

# s3 bucket for bootstrapping the firewall1
variable "bootstrap1" {}
variable "bootstrap2" {}
#variable "MasterS3Bucket" {}
#variable "bootstrap3" {}
#variable "bootstrap4" {}

# specify the region ami map
#Palo AMI region MAP version8.0.8
variable "BYOLPANFWRegionMap808" {
  type = "map"
  default =
    {
      "us-west-2" = "ami-4f118437",
      "ap-northeast-1" =   "ami-4bbcfa2c",
      "us-west-1"      =   "ami-d4f3f9b4",
      "ap-northeast-2" =   "ami-59419037",
      "ap-southeast-1" =   "ami-17a41074",
      "ap-southeast-2" =   "ami-10303673",
      "eu-central-1"   =   "ami-e93df486",
      "eu-west-1"      =   "ami-a0b5f5d9",
      "eu-west-2"      =   "ami-3d93745a",
      "sa-east-1"      =   "ami-1ff1ba73",
      "us-east-1"      =   "ami-66c63b1b",
      "us-east-2"      =   "ami-cb8eb9ae",
      "ca-central-1"   =   "ami-d4be39b0",
      "ap-south-1"     =   "ami-2a471945"
    }
}

#Palo AMI region MAP version8.0.9
variable "BYOLPANFWRegionMap809" {
  type = "map"
  default =
    {
      "us-west-2" = "ami-04273e64",
      "ap-northeast-1" =   "ami-621bec1d",
      "us-west-1"      =   "ami-04273e64",
      "ap-northeast-2" =   "ami-38b61e56",
      "ap-southeast-1" =   "ami-39586945",
      "ap-southeast-2" =   "ami-788a5b1a",
      "eu-central-1"   =   "ami-f3c2ed18",
      "eu-west-1"      =   "ami-ef80b096",
      "eu-west-2"      =   "ami-3bcc215c",
      "sa-east-1"      =   "ami-1eb2ee72",
      "us-east-1"      =   "ami-49900636",
      "us-east-2"      =   "ami-8e98a5eb",
      "ca-central-1"   =   "ami-9751d1f3",
      "ap-south-1"     =   "ami-d06e43bf"
    }
}
#Palo AMI region MAP version8.1.0
variable "BYOLPANFWRegionMap810" {
  type = "map"
  default =
    {
      "us-west-2" = "ami-d424b5ac",
      "ap-northeast-1" =   "ami-57662d31",
      "us-west-1"      =   "ami-a95b4fc9",
      "ap-northeast-2" =   "ami-49bd1127",
      "ap-southeast-1" =   "ami-27baeb5b",
      "ap-southeast-2" =   "ami-00d61562",
      "eu-central-1"   =   "ami-55bfd73a",
      "eu-west-1"      =   "ami-62b5fb1b",
      "eu-west-2"      =   "ami-876a8de0",
      "sa-east-1"      =   "ami-9c0154f0",
      "us-east-1"      =   "ami-a2fa3bdf",
      "us-east-2"      =   "ami-11e1d774",
      "ca-central-1"   =   "ami-64038400",
      "ap-south-1"     =   "ami-e780d988"
    }
}
#Palo AMI region MAP version8.0.9 PAYG Bundle 2
variable "PAYG2PANFWRegionMap80" {
  type = "map"
  default =
    {
      "us-west-2" = "ami-089be970",
      "ap-northeast-1" =   "ami-691ceb16",
      "us-west-1"      =   "ami-26243d46",
      "ap-northeast-2" =   "ami-e7b41c89",
      "ap-southeast-1" =   "ami-c05968bc",
      "ap-southeast-2" =   "ami-958b5af7",
      "eu-central-1"   =   "ami-f0c2ed1b",
      "eu-west-1"      =   "ami-26243d46",
      "eu-west-2"      =   "ami-089be970",
      "sa-east-1"      =   "ami-70bfe31c",
      "us-east-1"      =   "ami-b69305c9",
      "us-east-2"      =   "ami-8998a5ec",
      "ca-central-1"   =   "ami-3f51d15b",
      "ap-south-1"     =   "ami-ca6b46a5"
    }
}
#Palo AMI region MAP version8.0.9 PAYG Bundle 1
variable "PAYG1PANFWRegionMap809" {
  type = "map"
  default =
    {
"us-east-1" = "ami-ea950395",
"us-east-2" = "ami-3f9aa75a",
"us-west-1" = "ami-cb253cab",
"us-west2"  = "ami-3398ea4b",
"sa-east-1" = "ami-49b4e825",
"eu-west-1" = "ami-e19bab98",
"eu-west-2" = "ami-39cd205e",
"eu-central-1" = "ami-80c3ec6b",
"ca-central-1" = "ami-bd4eced9",
"ap-northeast-1" = "ami-491ceb36",
"ap-northeast-2" = "ami-3fb61e51",
"ap-southeast-1" = "ami-f85a6b84",
"ap-southeast-2" = "ami-ce8a5bac",
"ap-south-1" = "ami-5169443e" 
    }
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
