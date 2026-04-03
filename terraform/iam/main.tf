// IAM Role (per tenant)
resource "aws_iam_role" "tenant_role" {
  name = "tenant-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Tenant = "ec2-instance-role"
  }
}

// AWS-Secret-manager access
resource "aws_iam_policy" "secrets_access" {
  name = "secrets-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.aws_secretsmanager_secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secret" {
  depends_on = [aws_iam_role.tenant_role,aws_iam_policy.secrets_access  ]
  role       = aws_iam_role.tenant_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

// S3 Policy
resource "aws_iam_policy" "tenant_s3_policy" {
  name = "tenant-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:ListBucket"],
        Resource = var.s3_bucket_arn
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
            "${var.s3_bucket_arn}/*",
            "${var.s3_bucket_arn}/"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tenant_s3_attach" {
  role       = aws_iam_role.tenant_role.name
  policy_arn = [aws_iam_policy.tenant_s3_policy.arn]
  depends_on = [ aws_iam_role.tenant_role, aws_iam_policy.tenant_s3_policy ]
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy_attach" {
  role       = aws_iam_role.tenant_role.name
  policy_arn = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  depends_on = [ aws_iam_role.tenant_role ]
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCorePolicy_attach" {
  role       = aws_iam_role.tenant_role.name
  policy_arn = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  depends_on = [ aws_iam_role.tenant_role ]
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCorePolicy_attach" {
  role       = aws_iam_role.tenant_role.name
  policy_arn = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  depends_on = [ aws_iam_role.tenant_role ]
}

// IAM-github-OIDC-role
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-ssm-role"
  depends_on = [ aws_iam_openid_connect_provider.github ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:yashbabariya/multi-tenant-payroll-infrastructure:ref:refs/heads/main",
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  depends_on = [ aws_iam_role.github_actions_role ]
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  depends_on = [ aws_iam_role.github_actions_role ]
}