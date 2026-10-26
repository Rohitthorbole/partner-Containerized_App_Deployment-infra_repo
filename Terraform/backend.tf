// creating s3 for storing terraform state
resource "aws_s3_bucket" "my-s3" {
  bucket = "partner-containerized-app-deployment-terraform-state"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name    = "terraform-state"
    Purpose = "Terraform Remote State"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.my-s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.my-s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.my-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// creating dynamodb table for locking terraform state


resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "terraform-lock-table"
    Purpose = "Terraform State Locking"
  }
}
