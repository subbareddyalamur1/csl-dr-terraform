terraform {
  backend "s3" {
    bucket = "csl-dr-tf-state"
    key    = "DR/csl/val42/terraform.tfstate"
    region = "eu-central-1"
  }
}
