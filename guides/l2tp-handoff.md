---
title: L2TP Handoff
description: Use a MikroTik router for L2TP Handoff
category: Setup
author: FingerlessGloves
lastUpdated: 14/06/2026
---

# L2TP Handoff

## Overview

Some routers such as the Ubiquiti UniFi Gateways, do not support a L2TP client, which poses an issue trying to use the Olilo L2TP service.  
To get around this we can use a cheap MikroTik hEX Refresh (Approximately £50), which will allow us to passively add the L2TP service to another router, that doesn't have an L2TP Client.

This works by configuring a MikroTik to connect to the L2TP Service but not actually consume the IPs, but then give them out to another router physically connected to it.  
Effectively makes the L2TP completely transparent to the router, you can even request the IPs via DHCP.

For reference the MikroTik hEX Refresh can do 900 Mbit/s single stream in an iperf3 test. CPU hits about 80% overall.

You can also do this using MikroTik CHR, and do the same setup using a VM, but this guide is for physical MikroTik routers.

This configuration has been tested on MikroTik hEX Refresh and MikroTik RB5009

## Connectivity

- `ether1` will be the WAN that gives the MikroTik access to the internet via DHCP
- `ether2` is the L2TP Handoff
- `ether3` management network running DHCP Server (192.168.254.0/24)

You can either plug the ether1 connection in to your LAN, or plug an internet connection directly in to the ether1 port, by default it'll use DHCP to get an IP.  
MikroTik does support PPPoE, but it's worth noting the hEX Refresh may struggle to do 900mbit/s PPPoE and L2TP at the same time. This guide is for DHCP only.

Simply plug ether2 in to your router and DHCP will give you the L2TP IP, and if you wish to use IPv6, request the /48 prefix via DHCPv6.

## Configuration

When you first get a MikroTik device it'll have some form of default configuration applied and the login details provided in the box, gone are the days of generic passwords.  
We will want to connect to the router first, to clear the configuration and apply our custom configuration to get this working.

1. Download the [`l2tp-handoff.rsc`](https://raw.githubusercontent.com/Team-Olilo/wiki/main/files/l2tp-handoff.rsc) predefined configuration
1. Edit `l2tp-handoff.rsc` filling in the details at the top of the script, you'll find the details required in the `Your Olilo L2TP service is live` email
1. Login to your MikroTik using [WinBox](https://mikrotik.com/download/winbox), using the details found in the box
1. Go through the initial setup (changing the password, etc.)
1. On the left hand side click `Files`
1. Right side of the `Files` window, press `Upload` and select your `l2tp-handoff.rsc`
1. On the left hand side again, go to `System` -> `Reset Configuration`
1. Now we reset the device and apply the `l2tp-handoff.rsc`
    1. Select `No Default Configuration`
    1. Select `Do Not Backup`
    1. Click `+` on `Run After Reset`, type in `l2tp-handoff.rsc`
    1. Press the Green button of `Reset Configuration`
1. The MikroTik will now reboot to apply the configuration
1. Connect ether1 to your LAN/WAN
1. Connect ether2 to your Router (e.g. UniFi Gateway)
1. Configure your Router to use DHCP
1. You should now have your full Olilo L2TP connectivity
1. If you need to login to the MikroTik you can use ether3 to do this

## I have a /29

If you have a `/29` subnet you will need to add a route to the MikroTik for it to work.

Run the below command in the MikroTik terminal, remember to substitute `dst-address` for your `/29` and `gateway` for the main L2TP IP

```routeros
/ip/route add dst-address=your/29 gateway=yourl2tpip routing-table=olilo
```

## Manage MikroTik over ether1

If you want to access the MikroTik over ether1 instead of having to use ether3, this is possible but do NOT do this if you're plugging ether1 directly in to the internet.

Run the below command in the MikroTik terminal

```routeros
/interface/list/member add interface=ether1 list=management
```

You should now be able to contact the MikroTik on the IP it got on ether1 on your LAN for example

## Gotten stuck?

Ask for help in the Olilo Discord: **discord.gg/olilo**
