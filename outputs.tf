output "1. Openswan VPN Server IP" {
    value = "${aws_eip.openswan-server.public_ip}"
}
output "2. Openswan VPN Client Username" {
    value = "${var.vpn_username}"
}
output "3. Openswan VPN Client Password" {
    value = "${var.vpn_password}"
}
output "4. Openswan VPN Client Pre-Shared Key" {
    value = "${var.vpn_preshared_key}"
}