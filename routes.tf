## == Route tables == ##
resource "aws_route_table" "external" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.global["env"]}-rtb-${format("external-%03d", count.index+1)}"
    Environment = "${var.global["env"]}"
  }
}

resource "aws_route" "external" {
  count                  = "${length(split(",", var.global["subnets_ext"]))}"
  route_table_id         = "${aws_route_table.external.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table" "internal" {
  count  = "${length(split(",", var.global["subnets_int"]))}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.global["env"]}-rtb-${format("internal-%03d", count.index+1)}"
    Environment = "${var.global["env"]}"
  }
}

resource "aws_route" "internal" {
  count                  = "${length(split(",", var.global["subnets_int"]))}"
  route_table_id         = "${element(aws_route_table.internal.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

## == Route associations == ##
resource "aws_route_table_association" "internal" {
  count          = "${length(split(",", var.global["subnets_int"]))}"
  subnet_id      = "${element(aws_subnet.internal.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.internal.*.id, count.index)}"
}

resource "aws_route_table_association" "external" {
  count          = "${length(split(",", var.global["subnets_ext"]))}"  
  subnet_id      = "${element(aws_subnet.external.*.id, count.index)}"
  route_table_id = "${aws_route_table.external.id}"
}
