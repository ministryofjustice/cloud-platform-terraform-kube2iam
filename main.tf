
data "aws_iam_policy_document" "extra" {
  version = "2012-10-17"

  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
    effect    = "Allow"
  }

  # For ECR
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
    effect    = "Allow"
  }

}

resource "aws_iam_policy" "policy_default" {
  name   = "${var.cluster_domain_name}-default"
  path   = "/"
  policy = data.aws_iam_policy_document.extra.json
}

resource "aws_iam_role_policy_attachment" "eks_attach_default" {
  role       = var.iam_role_name_of_nodes
  policy_arn = aws_iam_policy.policy_default.arn
}

data "aws_iam_policy_document" "kube2iam" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    #resources = ["arn:aws:iam::${var.account_id}:role/k8s-*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "kube2iam_policy" {
  name   = "${var.cluster_domain_name}-kube2iam-assumerole"
  path   = "/"
  policy = data.aws_iam_policy_document.kube2iam.json
}

resource "aws_iam_role_policy_attachment" "attach_kube2iam" {
  role       = var.iam_role_name_of_nodes
  policy_arn = aws_iam_policy.kube2iam_policy.arn
}

# Allowing to be assumed, this is gonna be used by every app role
data "aws_iam_policy_document" "allow_to_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = [ var.iam_role_name_of_nodes ]
    }
  }
}


# Helm #

resource "helm_release" "kube2iam" {
  count = var.enable_kube2iam ? 1 : 0

  name       = "kube2iam"
  repository = "https://kubernetes-charts.storage.googleapis.com" 
  chart      = "kube2iam"
  namespace  = "kube2iam"
  version    = "1.0.0"

  values = [templatefile("${path.module}/templates/kube2iam.yaml.tpl", {})]

  depends_on = [
    var.dependence_deploy,
  ]
}
