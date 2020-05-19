# cloud-platform-terraform-kube2iam

This is the Kube2IAM terraform module used in EKS.

## Usage

```hcl
module "kube2iam" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-kube2iam?ref=0.0.1"

  iam_role_name_of_nodes = data.aws_iam_role.nodes.name
  cluster_domain_name    = data.terraform_remote_state.cluster.outputs.cluster_domain_name
  dependence_deploy      = "null_resource.deploy"
}

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable_kube2iam | Enable or not the kube2iam | bool | `true` | no |
| iam_role_name_of_nodes | Required to attach the policy, it is the name (not arn) of the EKS/Kops workers" | string | `` | yes |
| cluster_domain_name | The cluster domain used for externalDNS annotations and certmanager | string |  | yes |
| dependence_deploy | dependence_deploy | string |  | yes |

## Outputs

## Reading Material

- https://github.com/jtblin/kube2iam
