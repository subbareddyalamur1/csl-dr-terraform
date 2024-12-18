locals {
  inputs = yamldecode(file("${path.module}/inputs.yaml"))
}