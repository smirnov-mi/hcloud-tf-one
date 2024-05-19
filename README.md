# Setting up some infrastructure on Hetzer

using Terraform and Ansible


## Prerequisites

- Terraform
- Ansible
- Hetzner Cloud API Account and Token


## Usage

1. Clone the repository
1. EXPORT HCLOUD_TOKEN OR Create a `terraform.tfvars` file with the following content:
	```hcl
	hcloud_token = "your-hcloud-token"
	```


1. ~/git-my/hcloud-tf-one/1-infra/mycluster/base$ tf init
1. ~/git-my/hcloud-tf-one/1-infra/mycluster/base$ tf apply -auto-approve
1. ~/git-my/hcloud-tf-one/1-infra/mycluster/prod$ tf init
1. ~/git-my/hcloud-tf-one/1-infra/mycluster/prod$ tf apply -auto-approve


Then (TODO): Run the ansible playbooks to setup machines and install the k8s cluster

To destroy the infrastructure, run `tf destroy -auto-approve` in the `base` and `prod` directories:
1. ~/git-my/hcloud-tf-one/1-infra/mycluster/prod$ tf destroy -auto-approve
1. ~/git-my/hcloud-tf-one/1-infra/mycluster/base$ tf destroy -auto-approve



## See also

see [https://prasanthmj.github.io/terraform/](https://prasanthmj.github.io/terraform/)

https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_route

https://community.hetzner.com/tutorials/how-to-set-up-nat-for-cloud-networks

