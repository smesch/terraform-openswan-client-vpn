[global]
listen-addr = ${openswan-server-private-ip}
port = 1701

[lns default]
ip range = ${openswan-vpn-client-dhcp-start}-${openswan-vpn-client-dhcp-end}
local ip = ${openswan-server-private-ip}
require chap = no
unix authentication = yes
refuse pap = no
require authentication = yes
name = l2tpd
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
