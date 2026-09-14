output "cloudfront_domain_name" {
  description = "CloudFront Distribution domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront Distribution"
  value       = aws_cloudfront_distribution.cdn.id
}
