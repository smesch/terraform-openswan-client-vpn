# Openswan AWS Infrastructure
# Main Configuration File

# Specify AWS as the provider, AWS access details and a region
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

# Create a Security Group for the Openswan VPN Server
# Inbound Ports: 22, 1701 (UDP), 500 (UDP), 4500 (UDP)
# Outbound Ports: All

resource "aws_security_group" "openswan-server" {
  name        = "${var.tag_name}-server-sg"
  description = "Openswan VPN Server Security Group"
  vpc_id      = "${var.existing_vpc_id}"

  # SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # L2TP/IPSec UDP 1701 from anywhere
  ingress {
    from_port   = 1701
    to_port     = 1701
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # L2TP/IPSec UDP 500 from anywhere
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # L2TP/IPSec UDP 4500 from anywhere
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All ports within local subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.existing_vpc_cidr_block}"]
  }

  # Outbound to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Key Pair for EC2 Instances
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# Create Instance for Openswan Server
resource "aws_instance" "openswan-server" {
  depends_on                  = ["aws_security_group.openswan-server"]
  instance_type               = "t2.micro"
  ami                         = "${lookup(var.aws_amis, var.aws_region)}"
  key_name                    = "${aws_key_pair.auth.id}"
  vpc_security_group_ids      = ["${aws_security_group.openswan-server.id}", "${var.existing_default_sg_id}"]
  subnet_id                   = "${var.existing_subnet_id}"
  associate_public_ip_address = true
  source_dest_check           = false
  tags {
      Name = "${var.tag_name}-server"
  }
#  user_data                   = "${file("./files/user-data")}"  
}

# Create Elastic IP for Openswan Server
resource "aws_eip" "openswan-server" {
  instance = "${aws_instance.openswan-server.id}"
  vpc = true
}

# Provision Openswan Server Instance
resource "null_resource" "openswan-server-provisioning" {
  depends_on    = ["aws_instance.openswan-server"]
  connection {
    user        = "centos"
    key_file    = "${var.private_key_path}"
    agent       = false
    host        = "${aws_eip.openswan-server.public_ip}"
  }
  provisioner "file" {
    source      = "./files/"
    destination = "/tmp"
  }
  provisioner "file" {
    content     = "${template_file.openswan-script.rendered}"
    destination = "/tmp/openswan-script.sh"
  }
  provisioner "file" {
    content     = "${template_file.ipsec-conf.rendered}"
    destination = "/tmp/ipsec.conf"
  }
  provisioner "file" {
    content     = "${template_file.ipsec-secrets.rendered}"
    destination = "/tmp/ipsec.secrets"
  }
  provisioner "file" {
    content     = "${template_file.options-xl2tpd.rendered}"
    destination = "/tmp/options.xl2tpd"
  }
  provisioner "file" {
    content     = "${template_file.xl2tpd-conf.rendered}"
    destination = "/tmp/xl2tpd.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo chmod +x /tmp/openswan-script.sh",
      "sudo /tmp/openswan-script.sh"
    ]
  }  
}
