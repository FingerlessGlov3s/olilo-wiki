
:global l2tpUser    "olilologin@olilo.l2tp";  # your Olilo L2TP username
:global l2tpPass    "OliloPassword";          # your Olilo L2TP password
:global publicIP    "51.194.133.2";           # public IP Olilo assigns you
:global innerGw     "51.194.133.1";           # Use the same subnet Olilo assigns you and use .1
:global adminPassword "OliloChangeMe";        # admin password you want for the MikroTik admin user

/user
set admin password=$adminPassword
/interface ethernet
set [ find default-name=ether1 ] comment=WAN
set [ find default-name=ether2 ] arp=proxy-arp comment="L2TP handoff"
set [ find default-name=ether3 ] comment=Management
/interface list
add name=management
/ip pool
add name=olilo ranges=$publicIP
add name=management ranges=192.168.254.2-192.168.254.254
/ip dhcp-server
add address-pool=olilo always-broadcast=yes dynamic-lease-identifiers=client-mac interface=ether2 name=l2tp-handoff server-address=$innerGw
add address-pool=management interface=ether3 name=ether3
/ipv6 dhcp-server
add address-pool=olilo-pd interface=ether2 name=l2tp-handoff prefix-pool=olilo-pd
/ppp profile
add change-tcp-mss=yes comment="Olilo L2TP" name=olilo on-up=":delay 2; :local L \$\"local-address\"; /ip address remove [find interface=olilo-l2tp address~(\"^\" . \$L . \"/\")]" use-encryption=no
/interface l2tp-client
add add-default-route=yes allow-fast-path=yes connect-to=l2tp.olilo.co.uk disabled=no name=olilo-l2tp profile=olilo user=$l2tpUser password=$l2tpPass
/ip vrf
add interfaces=ether2,olilo-l2tp name=olilo
# 2 second delay to apply vrf
:delay 2
/ip neighbor discovery-settings
set discover-interface-list=management
/interface list member
add interface=ether3 list=management
/ip address
add address=192.168.254.1/24 interface=ether3 network=192.168.254.0
/ip arp
add address=$innerGw interface=ether2 published=yes
/ip dns
set servers=5.182.115.74@main,5.182.115.75@main
/ip dhcp-client
add comment=ether1 interface=ether1 name=ether1
/ip dhcp-server network
add address="$publicIP/32" dns-server=5.182.115.74,5.182.115.75 gateway=$innerGw
add address=192.168.254.0/24 gateway=192.168.254.1
/ip firewall filter
add action=fasttrack-connection chain=forward comment=fasttrack connection-state=established,related
add action=accept chain=forward comment="established, related" connection-state=established,related
add action=accept chain=forward comment="Allow Olilo inner l2tp" in-interface=olilo
add action=accept chain=forward comment="Allow management" in-interface-list=management
add action=drop chain=forward comment=Drop
add action=accept chain=input comment="established, related" connection-state=established,related
add action=accept chain=input comment="Allow Management" in-interface-list=management
add action=drop chain=input comment=Drop
add action=fasttrack-connection chain=output comment="fasttrack everything outbound" connection-state=established,related
/ip firewall mangle
add action=change-mss chain=postrouting comment="Olilo MSS Set" in-interface=olilo new-mss=1410 passthrough=no protocol=tcp tcp-flags=syn
/ip firewall nat
add action=masquerade chain=srcnat in-interface=ether3 out-interface=ether1
/ip route
add disabled=no distance=1 dst-address="$innerGw/32" gateway=olilo-l2tp@olilo routing-table=olilo scope=30 target-scope=10
add disabled=no distance=1 dst-address="$publicIP/32" gateway=ether2@olilo routing-table=olilo scope=30 target-scope=10
/ip service
set ftp disabled=yes
set telnet disabled=yes
set reverse-proxy disabled=yes
/ipv6 dhcp-client
add accept-prefix-without-address=no interface=olilo-l2tp pool-name=olilo-pd pool-prefix-length=48 request=address,prefix use-peer-dns=no
/ipv6 firewall filter
add action=accept chain=forward
add action=fasttrack-connection chain=forward comment=fasttrack connection-state=established,related
add action=accept chain=forward comment="established, related" connection-state=established,related
add action=accept chain=forward comment="Allow Olilo inner l2tp" in-interface=olilo
add action=accept chain=forward comment="Allow management" in-interface-list=management
add action=drop chain=forward comment=Drop
add action=accept chain=input comment="established, related" connection-state=established,related
add action=accept chain=input comment="Allow Management" in-interface-list=management
add action=accept chain=input comment="DHCPv6 PD client + server" dst-port=546,547 in-interface=olilo protocol=udp src-address=fe80::/10
add action=accept chain=input comment="ICMPv6 / ND" protocol=icmpv6
add action=drop chain=input comment=Drop
add action=fasttrack-connection chain=output comment="fasttrack everything outbound" connection-state=established,related
/ipv6 firewall mangle
add action=change-mss chain=postrouting in-interface=olilo new-mss=1390 passthrough=no protocol=tcp tcp-flags=syn
/ipv6 nd
add advertise-dns=yes interface=ether2 managed-address-configuration=yes
/system clock
set time-zone-name=Europe/London
/system identity
set name="L2TP Router"
/tool mac-server
set allowed-interface-list=management
/tool mac-server mac-winbox
set allowed-interface-list=management
/tool mac-server ping
set enabled=no
/file
remove l2tp-handoff.rsc