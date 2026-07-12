---
title: Guest Networks and VLANs on Your /48
description: How to segment your home network and give every VLAN its own IPv6 subnet
category: Advanced
author: Aydan Abrahams
lastUpdated: 06/07/2026
---

# Guest Networks and VLANs on Your /48

Every Olilo plan includes a routed **/48 IPv6** prefix, that's 65,536 individual `/64` subnets. You don't need to share one subnet across your whole network, every VLAN can have its own.

## Why bother segmenting

- **Guest Wi-Fi** shouldn't be able to see your NAS, printers, or smart home devices.
- **IoT/smart home devices** are often the least trustworthy things on a home network, isolate them.
- **Servers/homelab** traffic benefits from its own subnet with its own firewall rules, separate from everyday devices.

## A simple layout

Using an example `/48` of `2001:db8:1234::/48` (replace with your own routed prefix):

```text
Main LAN:  2001:db8:1234:0::/64
Servers:   2001:db8:1234:1::/64
IoT:       2001:db8:1234:2::/64
Guest:     2001:db8:1234:3::/64
```

Each VLAN gets the fourth hextet incremented, simple to remember, easy to expand. With a `/48` you have thousands of these to spare, don't be precious about "wasting" them.

## Setting it up

The exact steps depend on your router, but the shape is always the same:

1. Create the VLAN (a tagged sub-interface on your switch/router).
2. Assign it a `/64` from your `/48`.
3. Enable Router Advertisements (or DHCPv6) on that VLAN so devices actually pick up an address.
4. Write firewall rules between VLANs, e.g. block Guest and IoT from reaching Main LAN, while still allowing internet access.

See your router's specific setup guide (MikroTik, OPNsense, pfSense) for the exact IPv6/VLAN steps, the LAN IPv6 sections there use this same per-VLAN `/64` pattern.

## IPv4 side

You'll typically still use private IPv4 (RFC1918, e.g. `192.168.x.0/24`) per VLAN with NAT, your static public IPv4 sits on your WAN, not handed out per-VLAN. IPv6 is where you get to skip NAT entirely.

## A note on privacy addressing

Devices often show more than one IPv6 address, a stable one and a temporary "privacy" one that rotates. This is normal and expected, it's your devices protecting themselves from being tracked across networks by their IPv6 address, not a misconfiguration.

## Related guides

- CGNAT and Static IPs Explained
- MikroTik RouterOS Internet Setup Guide
- OPNsense Internet Setup Guide
- IPv6 Not Working? Troubleshooting
