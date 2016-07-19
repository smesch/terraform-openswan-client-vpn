ipcp-accept-local
ipcp-accept-remote
ms-dns ${openswan-vpn-client-dns1}
ms-dns ${openswan-vpn-client-dns2}
noccp
auth
crtscts
idle 1800
mtu 1280
mru 1280
lock
name l2tpd
proxyarp
connect-delay 5000
login
logfile /var/log/xl2tpd.log
