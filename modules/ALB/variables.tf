variable "instance_id" {
  description = "key name"
  type        = string
}

variable "aws_subnet_id" {
  description = "key name"
  type        = string
}

variable "aws_subnet_id_2" {
  description = "key name"
  type        = string
}


variable "security_groups" {
  description = "Subnet Id"
  type        = list(string)

}

variable "vpc_id" {
  description = "key name"
  type        = string
}
