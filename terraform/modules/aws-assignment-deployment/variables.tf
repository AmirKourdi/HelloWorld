# Example of a string variable
variable network_cidr {
  default = "172.31.45.245/30"
}

# Example of a list variable
variable availability_zones {
  default = ["eu-west-1a", "eu-west-1b"]
}

# Example of an integer variable
variable instance_count {
  default = 2
}

# Example of a map variable
variable ami_ids {
default = {
    "eu-west-1" = "ami-08ca3fed11864d6bb"
  }
}