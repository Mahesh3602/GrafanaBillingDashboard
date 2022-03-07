data "aws_billing_service_account" "main" {}

resource "aws_s3_bucket" "billing_logs" {
  bucket = "my-billing-tf-test-bucket"
}

resource "aws_s3_bucket_acl" "billing_logs_acl" {
  bucket = aws_s3_bucket.billing_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_billing_logging" {
  bucket = aws_s3_bucket.billing_logs.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketAcl", "s3:GetBucketPolicy"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-billing-tf-test-bucket",
      "Principal": {
        "AWS": [
          "${data.aws_billing_service_account.main.arn}"
        ]
      }
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-billing-tf-test-bucket/*",
      "Principal": {
        "AWS": [
          "${data.aws_billing_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}
