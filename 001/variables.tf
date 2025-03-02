variable "east_1_base" {
  type        = string
  description = "Eastern Region IP Block"
}

variable "west_1_base" {
  type        = string
  description = "Western Region IP Block"
}
variable "east_public_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Public Subnet CIDR values"
}

variable "east_private_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Private Subnet CIDR values"
}


variable "west_public_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Public Subnet CIDR values"
}

variable "west_private_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Private Subnet CIDR values"
}