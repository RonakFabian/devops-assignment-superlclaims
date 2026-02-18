provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "website-oac"
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "cdn" {

  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
resource "aws_s3_bucket_policy" "policy" {

  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}
