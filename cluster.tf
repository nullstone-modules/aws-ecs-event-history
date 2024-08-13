data "ns_connection" "cluster_namespace" {
  name     = "cluster-namespace"
  contract = "cluster-namespace/aws/ecs"
}

locals {
  cluster_arn  = data.ns_connection.cluster_namespace.outputs.cluster_arn
  cluster_name = data.ns_connection.cluster_namespace.outputs.cluster_name
}
