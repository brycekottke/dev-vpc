# // Subnet - Internal
resource "aws_subnet" "internal" {
  count             = "${length(split(",", var.global["subnets_int"]))}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block              = "${element(split(",", var.global["subnets_int"]), count.index)}"
  availability_zone       = "${element(split(",", var.global["azs"]), count.index)}"

  tags {
    Name = "${var.global["env"]}-${var.global["subnets_name"]}-${format("internal-%03d", count.index+1)}"
    Environment = "${var.global["env"]}"
  }
}

# // Subnet - External
resource "aws_subnet" "external" {
  count                   = "${length(split(",", var.global["subnets_ext"]))}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(split(",", var.global["subnets_ext"]), count.index)}"
  availability_zone       = "${element(split(",", var.global["azs"]), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.global["env"]}-${var.global["subnets_name"]}-${format("external-%03d", count.index+1)}"
    Environment = "${var.global["env"]}"
  }
}
