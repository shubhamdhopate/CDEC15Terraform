variable "image_id" {
  default = "ami-036841078a4b68e14"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "awscloudblitz"
}


variable "public_cidr_block" {
  type    = list(string) #required
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr_block" {
  type    = list(string) #requred
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type    = list(string) #required
  default = ["us-east-2a", "us-east-2b", "us-east-2c", ]
}