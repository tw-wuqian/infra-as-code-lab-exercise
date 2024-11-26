resource "aws_s3_bucket" "example" {
  bucket = "qian-bucket-1"

  tags = {
    Name        = "qian bucket"
    Environment = "Dev"
  }
}