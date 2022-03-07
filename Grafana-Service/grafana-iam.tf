resource "aws_iam_role" "grafana_role" {
  name = "grafana_role"
  assume_role_policy = "${file("iam-policy/grafana-assume-policy.json")}"

  tags = {
    CreatedBy = "Mahesh"
  }
}

resource "aws_iam_role_policy" "grafana_policy" {
  name = "grafana_policy"
  role = aws_iam_role.grafana_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = "${file("iam-policy/grafana-policy.json")}"
}

