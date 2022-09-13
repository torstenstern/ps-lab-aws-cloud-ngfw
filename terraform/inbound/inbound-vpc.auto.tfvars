
inbound-vpc = {
    name                 = "att-vpc"
    cidr_block           = "10.4.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    internet_gateway     = true
}

inbound-vpc-route-tables = [
  { name = "rt", "subnet" = "subnet" }
]

inbound-vpc-routes = {
  inb-vpc-tgw = {
    name          = "inb-vpc-tgw"
    vpc_name      = "inb-vpc"
    route_table   = "rt"
    prefix        = "10.4.0.0/16"
    next_hop_type = "transit_gateway"
    next_hop_name = "tgw"
  },
  inb-vpc-igw = {
    name          = "inb-vpc-igw"
    vpc_name      = "inb-vpc"
    route_table   = "rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "inb-vpc"
  }
}

inbound-vpc-security-groups = [
  {
    name = "inb-svr-sg"
    rules = [
      {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit All Internal traffic"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 1389"
        type        = "ingress", from_port = "1389", to_port = "1389", protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
      },
      {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit ICMP Public"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "icmp"
        cidr_blocks = ["10.1.0.0/16"]
      }
    ]
  }
]

inbound-vpc-subnets = [
  { name = "alb-subnet", cidr = "10.4.1.0/24", az = "a" },
  { name = "tgw-subnet", cidr = "10.4.0.0/24", az = "a" },
  { name = "alb-subnet", cidr = "10.4.2.0/24", az = "b" },
  { name = "tgw-subnet", cidr = "10.4.3.0/24", az = "b" }
]
