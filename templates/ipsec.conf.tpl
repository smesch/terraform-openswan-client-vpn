version 2.0

config setup
    dumpdir=/var/run/pluto/
    plutostderrlog=/var/log/pluto.log
    nat_traversal=yes
    virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
    oe=off
    protostack=netkey
    nhelpers=0
    interfaces=%defaultroute

conn L2TP-PSK
    auto=add
    left=%defaultroute
    leftid=${openswan-server-private-ip}
    leftsourceip=${openswan-server-private-ip}
    leftnexthop=%defaultroute
    leftprotoport=17/%any
    rightprotoport=17/%any
    right=%any
    rightsubnet=vhost:%no,%priv
    forceencaps=yes
    authby=secret
    pfs=no
    type=transport
    auth=esp
    dpddelay=30
    dpdtimeout=120
    dpdaction=clear
