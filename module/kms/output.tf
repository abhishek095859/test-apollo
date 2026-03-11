output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = aws_kms_key.this.arn # Ensure 'this' matches your resource name in main.tf
}