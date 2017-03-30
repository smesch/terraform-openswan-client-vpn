output "openswan_vpn_server_ip" {
  value = "${aws_eip.openswan-server.public_ip}"
}

output "openswan_vpn_client_username" {
  value = "${var.vpn_username}"
}

output "openswan_vpn_client_password" {
  value = "${var.vpn_password}"
}

output "openswan_vpn_client_pre_shared_key" {
  value = "${var.vpn_preshared_key}"
}
