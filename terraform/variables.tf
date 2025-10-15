variable "kubernetes_version" {
  default = 1.34
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "aws_region" {
  default = "us-east-1"
}

locals {
  cluster_name = "openwebui-ollama-eks"
}
