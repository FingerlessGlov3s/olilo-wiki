---

title: OPNSense v26 - Configuring public IPv6 on client

description: how to configure OPNSense to provide a client with a IPv6 GUA

category: Setup

author: Tim Draper (Tau)

lastUpdated: 16/06/2026

---
# OPNSense - Configuring public IPv6 on client
This guide runs through configuring OPNSense v26.x with an IPv6 GUA. It is built around OpenReach but should be transferable to other providers.

This guide assumes you already have basic IPv4 internet connectivity to Olilo, a single WAN and one or more LAN interfaces. It also assumes you have basic knowledge of network interfaces, and your OS of choice to check IP addresses. Understanding of types of IPv6 addresses would be advantageous but not essential.

Olilo provide both SLAAC and DHCPv6. DHCPv6 appears to be the preferred option.

Toggling `full help` in OPNSense interface may help you understand more about the individual settings.

## Terminology
GUA = IPv6 Globally Unique Address. This is a public IP address.

## WAN Interface
in OPNSense, goto `Interfaces > WAN` 

-  **IPv6 Configuration Type**: DHCPv6

A new section `DHCPv6 client configuration` will appear further down the page.
Keep the default values and change the following:

- **Prefix delegation size**: 48
- **Request prefix only**: Ticked
- **Request DNS configuration**: Ticked
- **Send prefix hint**: Ticked
 
Click Save & Apply Settings.

WAN does not appear to update  these changes until a reboot. Reboot now!

After reboot, look at `System > Gateways > Configuration`. You should see at least two entries. One as your `WAN_PPPoE` (IPv4) gateway, and a second `WAN_DHCP6` (IPv6) gateway.
Note that the WAN_DHCP6 interface does not have a GUA and likely only have an `fe80::` address . This is expected and working correctly.

## LAN Interface
Since we are configuring this from scratch, it would be best to use a test network before deploying to your main network. I will use my Test VLAN40 interface (named `40_Test`) but the process is the same for any LAN interface.
`Assign prefix ID` should be unique in your network to avoid an potential conflict. I use the VLAN ID, but it can be anything.

in OPNSense, goto `Interfaces > 40_Test`

- **IPv6 Configuration Type**: Identity Association

A new section `IPv6 Identity Association` will appear further down the page.

- **Parent interface**: Select your WAN interface
- **Assign prefix ID**: 40

Click Save & Apply Settings

## Router Advertisement
in OPNSense, goto `Services > Router Advertisements`
click the `+` button to Add a new interface.

- **Enabled**: ticked
- **Interface**: Select your LAN interface (`40_Test` for this guide)
- **Mode**: Assisted

Click Save & Apply

## Firewall
OPNSense has a `Default allow LAN to any rule` set on the default LAN firewall interface. Depending on the config of your router, this may not be configured for IPv4+IPv6. If not, simply edit the the rule and update the following:

- **version**: IPv4+IPv6

Save & apply.

## Testing
On a test device, renew your IP.  (disconnect & reconnect your network connection is arguably easiest)
Check your IP address. You should see a GUA IPv6 address provided This will look similar to `2001:0db8:85a3:40:0000:8a2e:0370:7334/64`

Assuming you have a static IPv6 /48 range, the first 3 hextets are your IP range. take note of this for your records. 
the 4th hextet is your `Prefix ID` as chosen in the LAN stage.
the last 4 hextets is your unique client address.

The website https://test-ipv6.com and/or https://test-ipv6.run should now report you have a 10/10 IPv6 score. Other IPv6 websites should also work.

## Final Steps & Thoughts
Assuming you have a static IPv6 /48 range, the first 3 hextets (IPv4 equivalent of octets) are your IP range. take note of this for your records.

Run through the LAN interface and Router Advertisement steps for each additional interface you require a GUA on. We only ran through one test LAN interface so will only work on that.

Since GUAs are based on the IPv6 range that the ISP provides to you, this will change if you move ISP provider. The same as your public IPv4 address would if you moved ISP. GUA's should **not** replace local/LAN IP addresses and *should* be used along side them.

A DHCP reservation can be created to ensure the client will receive the same GUA address in at the next DHCP renewal. This will allow you to create stable and secure firewall rules.
