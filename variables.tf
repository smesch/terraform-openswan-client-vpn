# Openswan AWS Infrastructure
# Variable Configuration File

# AWS Region
variable "aws_region" {
  description = "AWS Region (ex: us-east-1)"
}

# Existing AWS Resources
variable "existing_vpc_id" {
  description = "AWS Existing VPC ID (ex: vpc-12345678)"
}

variable "existing_vpc_cidr_block" {
  description = "AWS Existing VPC CIDR Block (ex: 192.168.100.0/21)"
}

variable "existing_subnet_id" {
  description = "AWS Existing Subnet ID  (ex: subnet-12abcd3e)"
}

variable "existing_subnet_cidr_block" {
  description = "AWS Existing Subnet CIDR Block (ex: 192.168.101.0/24)"
}

variable "dhcp_start_host" {
  description = "The host number for the start of the VPN DHCP range (ex: 245). If you specify \"245\" and the \"existing_subnet_cidr_block\" is \"192.168.101.0/24\" the start of your DHCP range would be \"192.168.101.245\"."
}

variable "dhcp_end_host" {
  description = "The host number for the end of the VPN DHCP range (ex: 249). If you specify \"249\" and the \"existing_subnet_cidr_block\" is \"192.168.101.0/24\" the end of your DHCP range would be \"192.168.101.249\"."
}

variable "existing_default_sg_id" {
  description = "AWS Existing Default Security Group ID (ex: sg-123ab45c)"
}

# New Items
variable "public_key_path" {
  description = "Path to Public Key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to Private Key"
  default     = "~/.ssh/id_rsa"
}

variable "key_name" {
  description = "Name of New AWS Key Pair"
  default     = "aws-keypair-01"
}

variable "tag_name" {
  description = "Name Tag Prefix"
  default     = "openswan"
}

variable "vpn_username" {
  description = "VPN User Username"
  default     = "vpnuser"
}

variable "vpn_password" {
  description = "VPN User Password"
}

variable "vpn_preshared_key" {
  description = "VPN Pre-Shared Key"
}

# CentOS 7 (x86_64) - with Updates HVM (02/25/16)
variable "aws_amis" {
  default = {
    eu-central-1 = "ami-9bf712f4"
    eu-west-1    = "ami-7abd0209"
    sa-east-1    = "ami-26b93b4a"
    us-east-1    = "ami-6d1c2007"
    us-west-1    = "ami-af4333cf"
    us-west-2    = "ami-d2c924b2"
  }
}
