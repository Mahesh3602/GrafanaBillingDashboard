resource "aws_cloudformation_stack" "cfn-athena-stack" {
  name = "cfn-athena-stack"
  template_url = "https://my-billing-tf-test-bucket.s3.amazonaws.com/AWS/BillingReport/example-cur-report-definition/crawler-cfn.yml"
  disable_rollback = true
  capabilities = ["CAPABILITY_IAM"]
  
}