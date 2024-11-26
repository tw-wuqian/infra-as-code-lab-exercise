terraform {
  backend "s3" {
    bucket         = "qian-bucket-1"
    key            = "qian-iac-lab/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "qian-iac-lab-tfstate-locks"
    encrypt        = true
  }
}