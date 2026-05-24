resource "aws_eks_cluster" "vasylkly" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.vasylkly-cluster.id]
    subnet_ids         = var.subnets_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSVPCResourceController,
  ]
  tags = merge(
    var.tags,
    { Name = "${var.name}" }
  )
}

data "aws_eks_cluster_auth" "vasylkly" {
  name = aws_eks_cluster.vasylkly.name
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = var.name
  addon_name                  = "coredns"
  addon_version               = "v1.12.4-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [aws_eks_node_group.vasylkly]
}
