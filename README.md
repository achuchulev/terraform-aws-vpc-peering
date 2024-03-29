# Terraform code to create peering between two AWS VPCs

## Prerequisites

- git
- terraform ( >= 0.13 )
- AWS subscription

## How to use

### Clone the repo

```
git clone https://github.com/achuchulev/terraform-aws-vpc-peering.git
cd terraform-aws-vpc-peering
```

### Create `terraform.tfvars` file

#### Inputs

| Name  |	Description |	Type |  Default |	Required
| ----- | ----------- | ---- |  ------- | --------
| requester_aws_access_key | Requester AWS access key | string  | - | yes
| accepter_aws_access_key | Accepter AWS access key | string  | - | yes
| requester_aws_secret_key | Requester AWS secret key | string  | - | yes
| accepter_aws_secret_key | Accepter AWS secret key | string  | - | yes
| requester_region | Requester AWS region | string  | - | yes
| accepter_region | Accepter AWS region | string  | - | yes
| requester_vpc_id  | Requester VPC id | string | - | yes
| accepter_vpc_id  | Accepter VPC id | string | - | yes
| enabled  | Set to false to prevent the module from creating or accessing any resources | string | true | no
| requester_peer_tags  | Requester peer tags | map | Side = "Requester"   Name = "VPC01-VPC02" | no
| accepter_peer_tags  | Accepter peer tags | map  | Side = "Accepter"  Name = "VPC01-VPC02" | no
| requester_vpc_tags  | Requester VPC tags | map  | {} | no
| accepter_vpc_tags | Accepter VPC tags  | map  | {} | no
| requester_route_tables_count | Route tables count of requester's VPC | number | 1 | no 
| requester_route_tables_count | Route tables count of accepter's VPC | number | 1 | no 

```
Note: You can use "enabled" variable as a switch to create | destroy peering between VPC on demand. 
```

### Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will create:
  - vpc peering connection that represents the requester
  - accepter vpc peering connection
  - route(s) from requester to accepter
  - route(s) from accepter to requester
  
  
#### Outputs

| Name  |	Description 
| ----- | ----------- 
| connection_id | VPC peering connection ID
| accept_status | The status of the VPC peering connection request
