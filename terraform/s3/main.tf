resource "aws_s3_bucket" "payroll" {
  bucket = "payroll-secure-bucket-demo"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.payroll.id

  versioning_configuration {
    status = "Enabled"
  }
}