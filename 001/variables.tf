variable "east_public_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "east_private_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "west_public_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Public Subnet CIDR values"
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "west_private_subnet_cidrs" {
  type        = list(string)
  description = "Eastern Region Private Subnet CIDR values"
  default     = ["10.2.3.0/24", "10.2.4.0/24"]
}