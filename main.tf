# --- terraformとawsのバージョンを指定 ---
terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.57.0"
    }
  }
}
