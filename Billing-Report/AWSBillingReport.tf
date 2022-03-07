resource "aws_cur_report_definition" "example_cur_report_definition" {
  report_name                = "example-cur-report-definition"
  time_unit                  = "DAILY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = "my-billing-tf-test-bucket"
  s3_region                  = "us-east-1"
  additional_artifacts       = ["ATHENA"]
  s3_prefix                  = "AWS/BillingReport"
  report_versioning          = "OVERWRITE_REPORT"

  depends_on = [aws_s3_bucket.billing_logs]
}