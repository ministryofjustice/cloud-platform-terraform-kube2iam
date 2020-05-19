variable "enable_kube2iam" {
  description = "Enable or not the kube2iam"
  type        = bool
  default     = true
}

variable "iam_role_name_of_nodes" {
  description = "Required to attach the policy, it is the name (not arn) of the EKS/Kops workers"
  type        = string
}

variable "cluster_domain_name" {
  description = "The cluster domain used for externalDNS annotations and certmanager"
}

variable "dependence_deploy" {
  description = "Deploy Module dependence in order to be executed (deploy resource is the helm init)"
}
