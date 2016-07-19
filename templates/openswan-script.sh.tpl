#!/bin/bash
#Install and Configure RNG
yum -y install epel-release
yum -y install rng-tools
yes | cp -rf /tmp/rngd /etc/sysconfig/rngd
systemctl start rngd

#Install and Configure Openswan
yum -y install openswan
yes | cp -rf /tmp/ipsec.conf /etc/ipsec.conf
yes | cp -rf /tmp/ipsec.secrets /etc/ipsec.secrets

sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.conf.eth0.send_redirects=0
sysctl -w net.ipv4.conf.eth0.accept_redirects=0
sysctl -w net.ipv4.conf.eth0.rp_filter=0
sysctl -w net.ipv4.conf.lo.send_redirects=0
sysctl -w net.ipv4.conf.lo.accept_redirects=0
sysctl -w net.ipv4.conf.lo.rp_filter=0

sysctl -w net.ipv4.ip_forward=1

sysctl -w net.ipv4.conf.all.proxy_arp=1
sysctl -w net.ipv4.conf.default.proxy_arp=1
sysctl -w net.ipv4.conf.eth0.proxy_arp=1
sysctl -w net.ipv4.conf.lo.proxy_arp=1

systemctl start ipsec

#Install and Configure XL2TPD
yum -y install xl2tpd

yes | cp -rf /tmp/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
yes | cp -rf /tmp/options.xl2tpd /etc/ppp/options.xl2tpd
yes | cp -rf /tmp/pap-secrets /etc/ppp/pap-secrets
yes | cp -rf /tmp/ppp /etc/pam.d/ppp

systemctl start xl2tpd

#Configure NAT Masquerade
iptables -L -n
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -A POSTROUTING -j MASQUERADE

#Create VPN User
useradd ${openswan-vpn-username}
echo '${openswan-vpn-password}' | passwd --stdin ${openswan-vpn-username}