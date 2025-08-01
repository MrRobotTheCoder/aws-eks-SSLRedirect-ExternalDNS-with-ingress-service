# Resource: AWS IAM Role
resource "aws_iam_role" "eks_admin_role" {
  name = "${local.name}-eks-admin-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
  
  tags = {
    tag-key = "${local.name}-eks-admin-role"
  }
}

# Resource: AWS IAM Role Inline Policy (external resource now)
resource "aws_iam_role_policy" "eks_admin_policy" {
  name = "eks-full-access-policy"
  role = aws_iam_role.eks_admin_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:ListRoles",
          "eks:*",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}