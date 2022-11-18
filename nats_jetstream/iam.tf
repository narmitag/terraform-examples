data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
        "ssm.amazonaws.com",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "nats-role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "instance_policy_attach_1" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "instance_policy_attach_2" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# data "aws_iam_policy_document" "kms_key_policy_iam_profile" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "kms:Decrypt"
#     ]
#     resources = ["arn:aws:kms:eu-west-2:111788162356:key/687c6551-d552-4e30-9055-3bbc889f875f"]
#   }
# }

data "aws_iam_policy_document" "s3_policy_iam_profile" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*"
    ]
    resources = [aws_s3_bucket.assets.arn,"${aws_s3_bucket.assets.arn}/*"]
  }
}

data "aws_iam_policy_document" "parameter_policy_iam_profile" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:PutParameter"
    ]
    resources = ["*"]
  }
}


# resource "aws_iam_role_policy" "kms" {
#   role   = aws_iam_role.instance_role.name
#   name   = "inline-policy-kms-access"
#   policy = data.aws_iam_policy_document.kms_key_policy_iam_profile.json
# }

resource "aws_iam_role_policy" "s3" {
  role   = aws_iam_role.instance_role.name
  name   = "inline-policy-s3-access"
  policy = data.aws_iam_policy_document.s3_policy_iam_profile.json
}

resource "aws_iam_role_policy" "parameter" {
  role   = aws_iam_role.instance_role.name
  name   = "inline-policy-param-access"
  policy = data.aws_iam_policy_document.parameter_policy_iam_profile.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name  = "nats-instance-profile-neil"
  role  = aws_iam_role.instance_role.name
}
