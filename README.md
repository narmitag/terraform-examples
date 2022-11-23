# terraform-examples

Random selection of terraform code, they should run from ok from a sub-directory with a valid AWS connection

* transit_gateway
* vpc_peering
* nats_jetstream
* ecs
* ssm_bastion (with no NAT gateway so create's the required VPC endpoints)

Run Tests 
```
 cd test
 go test -v -timeout 30m
 ```