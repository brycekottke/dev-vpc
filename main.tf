resource "aws_vpc" "main" {
  cidr_block           = "${var.global["vpc_cidr"]}"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_subnet" "internal" {
  count             = "${length(split(",", var.global["subnet_int"]))}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(split(",", var.global["subnets_int"]), count.index)}"
  availability_zone = "${element(split(",", var.global["azs"]), count.index)}"
}
