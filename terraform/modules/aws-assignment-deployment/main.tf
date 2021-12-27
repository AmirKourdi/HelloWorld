resource "aws_security_group" "elb_sg" {
  name        = "ELB Security Group"
  description = "Allow incoming HTTP traffic from the internet"
  vpc_id      = "vpc-0d6858f120ab89040"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "Web Server Security Group"
  description = "Allow HTTP traffic from ELB security group"
  vpc_id      = "vpc-0d6858f120ab89040"

  # HTTP access from the VPC
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
                                
resource "aws_instance" "web" {
  count         = "${var.instance_count}"
  # lookup returns a map value for a given key
  ami           = "${lookup(var.ami_ids, "eu-west-1")}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id     = "subnet-05a5de4bc5ee448ec"
    
  # Use instance user_data to serve the custom website
  user_data              = "${file("/Users/akourdi/HelloWorld/terraform/modules/aws-assignment-deployment/template/user_data.sh")}"

  # Attach the web server security group
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  key_name = "akourdi"

  tags = {
    Name: "Web Server ${count.index + 1}"
    Candidate: "AmirKourdi"
  }
}

resource "aws_elb" "web" {
  name = "web-elb"
  subnets = ["subnet-05a5de4bc5ee448ec","subnet-05a5de4bc5ee448ec"]
  security_groups = ["${aws_security_group.elb_sg.id}"]
  instances = "${aws_instance.web.*.id}"


  # Listen for HTTP requests and distribute them to the instances
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  # Check instance health every 10 seconds
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
}
