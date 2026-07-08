##################################################
# S3 BUCKET

resource "aws_s3_bucket" "website" {

  bucket = var.website_bucket_name

  tags = local.common_tags

}

##################################################
# STATIC WEBSITE HOSTING

resource "aws_s3_bucket_website_configuration" "website" {

  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

}

##################################################
# PUBLIC ACCESS SETTINGS

resource "aws_s3_bucket_public_access_block" "website" {

  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

##################################################
# BUCKET POLICY

resource "aws_s3_bucket_policy" "website" {

  bucket = aws_s3_bucket.website.id

  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "PublicRead"

        Effect = "Allow"

        Principal = "*"

        Action = [
          "s3:GetObject"
        ]

        Resource = [
          "${aws_s3_bucket.website.arn}/*"
        ]

      }

    ]

  })

}

##################################################
# INDEX.HTML

resource "aws_s3_object" "index" {

  bucket = aws_s3_bucket.website.id

  key = "index.html"

  source = "../frontend/index.html"

  etag = filemd5("../frontend/index.html")

  content_type = "text/html"

}

##################################################
# STYLE.CSS

resource "aws_s3_object" "style" {

  bucket = aws_s3_bucket.website.id

  key = "style.css"

  source = "../frontend/style.css"

  etag = filemd5("../frontend/style.css")

  content_type = "text/css"

}

##################################################
# SCRIPT.JS

resource "aws_s3_object" "script" {

  bucket = aws_s3_bucket.website.id

  key = "script.js"

  source = "../frontend/script.js"

  etag = filemd5("../frontend/script.js")

  content_type = "application/javascript"

}