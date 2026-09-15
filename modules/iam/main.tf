# 1. IAM Assume Role Policy for EC2
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.tags, { Name = "${var.project_name}-ec2-role" })
}

# 2. SSM Policy for secure management (No SSH keys required)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 3. CloudWatch Agent Policy for log pushing & custom metrics
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# 4. S3 Bucket Access Policy
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid    = "S3AppBucketAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name   = "${var.project_name}-s3-access-policy"
  policy = data.aws_iam_policy_document.s3_access.json
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# 5. Secrets Manager Access Policy
data "aws_iam_policy_document" "secrets_access" {
  statement {
    sid    = "AllowReadAppSecrets"
    effect = "Allow"
    actions = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [var.secret_arn]
  }
}

resource "aws_iam_policy" "secrets_access" {
  name   = "${var.project_name}-secrets-access-policy"
  policy = data.aws_iam_policy_document.secrets_access.json
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

# 6. IAM Instance Profile for Launch Template
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.app_role.name

  tags = merge(var.tags, { Name = "${var.project_name}-instance-profile" })
}
