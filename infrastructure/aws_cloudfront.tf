# https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html

resource "aws_cloudfront_distribution" "web" {
  enabled = true
  aliases = ["tomohiro.me", "www.tomohiro.me"]

  origin {
    domain_name = "tomohiro.github.io"
    origin_id   = "origin-tomohiro-github-pages"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  logging_config {
    bucket = "tomohiro-logs.s3.amazonaws.com"
    prefix = "AWSLogs/627601271476/CloudFront/"
  }

  default_cache_behavior {
    target_origin_id       = "origin-tomohiro-github-pages"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:627601271476:certificate/b3a149d2-e2f7-4467-af0e-42b7a226bac4"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}
