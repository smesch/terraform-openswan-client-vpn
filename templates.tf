# Openswan AWS Infrastructure
# Template Configuration File

resource "template_file" "ipsec-conf" {
    filename = "./templates/ipsec.conf.tpl"
    vars {
        openswan-server-private-ip = "${aws_instance.openswan-server.private_ip}"
    }
}

resource "template_file" "ipsec-secrets" {
    filename = "./templates/ipsec.secrets.tpl"
    vars {
        openswan-server-private-ip = "${aws_instance.openswan-server.private_ip}"
        openswan-server-public-ip  = "${aws_eip.openswan-server.public_ip}"
        openswan-preshared-key     = "${var.vpn_preshared_key}"
    }
}

resource "template_file" "options-xl2tpd" {
    filename = "./templates/options.xl2tpd.tpl"
    vars {
        openswan-vpn-client-dns1 = "8.8.8.8"
        openswan-vpn-client-dns2 = "8.8.4.4"
    }
}

resource "template_file" "xl2tpd-conf" {
    filename = "./templates/xl2tpd.conf.tpl"
    vars {
        openswan-server-private-ip     = "${aws_instance.openswan-server.private_ip}"
        openswan-vpn-client-dhcp-start = "${var.existing_subnet_prefix}.245"
        openswan-vpn-client-dhcp-end   = "${var.existing_subnet_prefix}.249"
    }
}

resource "template_file" "openswan-script" {
    filename = "./templates/openswan-script.sh.tpl"
    vars {
        openswan-vpn-username = "${var.vpn_username}"
        openswan-vpn-password = "${var.vpn_password}"
    }
}