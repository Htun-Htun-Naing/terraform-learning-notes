resource "aws_dynamodb_table" "nautilus-table" {
  name           = var.KKE_TABLE_NAME
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    Name        = var.KKE_TABLE_NAME
    Environment = "production"
  }
}

resource "aws_iam_role" "nautilus-role" {
    name = var.KKE_ROLE_NAME
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
        Action = "sts:AssumeRole"
        Effect   = "Allow"
        Principle = {
            Service = "ec2.amazonaws.com"
        }
        },
    ]
    })
    tags = {
        Name = var.KKE_ROLE_NAME
    }
}

resource "aws_iam_policy" "nautilus-readonly-policy" {
    name        = var.KKE_POLICY_NAME
    description = "Nautilus readonly policy"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
        Action = [
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query"
        ]
        Effect   = "Allow"
        Resource = [
            aws_dynamodb_table.nautilus-table.arn
        ]
        },
    ]
    })
}

resource "aws_iam_role_policy_attachment" "nautilus-read-only-attachment" {
    role       = aws_iam_role.nautilus-role.name
    policy_arn = aws_iam_policy.nautilus-readonly-policy.arn
}