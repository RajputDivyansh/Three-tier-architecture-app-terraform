// IAM Role and Policy for EC2 Instances
data "aws_iam_policy_document" "ec2_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}


// IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_role" {

  name = "${var.project_name}-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


// Attach SSM Managed Instance Core Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


// Attach CloudWatch Agent Server Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "cloudwatch" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

// Attach S3 Read Only Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "s3_readonly" {

  role       = aws_iam_role.ec2_role.name
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

// Attach EC2 Read Only Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "ec2_readonly" {

  role       = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


// Custom Policy for Secrets Manager Access
resource "aws_iam_role_policy" "secrets_manager" {

  name = "${var.project_name}-secrets-manager"

  role = aws_iam_role.ec2_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = "*"
      }
    ]
  })
}


// Custom Policy for Parameter Store Access
resource "aws_iam_role_policy" "parameter_store" {

  name = "${var.project_name}-parameter-store"

  role = aws_iam_role.ec2_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [

          "ssm:GetParameter",

          "ssm:GetParameters",

          "ssm:GetParametersByPath"
        ]

        Resource = "*"
      }
    ]
  })
}


// IAM Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2_profile" {

  name = "${var.project_name}-instance-profile"

  role = aws_iam_role.ec2_role.name
}