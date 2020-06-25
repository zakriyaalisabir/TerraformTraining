# provider "aws" {
#     region = "${var.AWS_REGION}"
#     shared_credentials_file = "~/.aws/credentials"
#     profile = "465976519110"
# }

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}