provider "aws" {
  region                  = "${lookup(var.region, terraform.env)}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}