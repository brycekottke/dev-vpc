## == VPC == ##
resource "aws_vpc" "main" {
  cidr_block           = "${var.global["vpc_cidr"]}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.global["env"]}-${var.global["vpc_name"]}"
    Environment = "${var.global["env"]}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.global["env"]}-${var.global["vpc_name"]}"
    Environment = "${var.global["env"]}"
  }
}

# // NAT Gateway with EIP
resource "aws_nat_gateway" "main" {
  count = "${length(split(",", var.global["subnets_ext"]))}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.external.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.main"]
}

resource "aws_eip" "nat" {
  count = "${length(split(",", var.global["subnets_ext"]))}"
  vpc   = true
}
