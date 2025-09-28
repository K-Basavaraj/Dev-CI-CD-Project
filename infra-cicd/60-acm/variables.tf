variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "zone_name" {
  default = "awsdevopsjourney.online"
}

variable "zone_id" {
  default = "Z05938801WWDCVGH84GRE"
}