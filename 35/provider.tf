provider "aws" {
  region = local.inputs.aws_region

  default_tags {
    tags = local.inputs.tags
  }
}
