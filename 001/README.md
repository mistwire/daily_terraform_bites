A good exercise would be to design and implement a production-ready multi-regional network on AWS. 

1. Start by creating a VPC with the CIDR range of 10.0.0.0/16 in Region A, 
2. Define 4 subnets within this range
3. Another VPC in Region B, which has the CIDR range 10.1.0.0/16, 
4. Another 4 subnets (2 public, 2 private)
5. Set up VPC peering between them 
6. Implement routing and firewall rules.