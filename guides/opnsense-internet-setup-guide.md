---
title: OPNsense Internet Setup Guide
description: Configuring your main WAN connection and IPv6 on OPNsense for Openreach, CityFibre, or Freedom Fibre
category: Setup
author: Aydan Abrahams, Tim Draper (Tau)
lastUpdated: 12/07/2026
---

# OPNsense Internet Setup Guide

This covers your **main internet connection** on OPNsense. If you want Olilo's L2TP tunnel service instead (a separate, additional service), see the **L2TP Guide**, which covers the point-to-point L2TP client setup specifically.

Check [Which Network Am I On?](./which-network-am-i-on.md) first, the WAN configuration differs by network.

Toggling `full help` in the OPNsense interface may help you understand more about the individual settings referenced below.

---

## Openreach (PPPoE)

Go to **Interfaces → [WAN]**.

```text
IPv4 Configuration Type: PPPoE
Username:                your Olilo PPPoE username
Password:                your Olilo PPPoE password
```

Your credentials are supplied by email after your order goes live, and are case-sensitive.

```text
IPv6 Configuration Type: DHCPv6

DHCPv6 client configuration
Prefix delegation size:    48
Request DNS configuration: Untick
```

Also enable, if available on your version:

```text
Use IPv4 connectivity as parent interface (for IPv6): Tick
```

**Save** and **Apply Changes**.

> If you're going to use the **Identity Association** method for LAN IPv6 below (Method B), also tick **Request prefix only** and **Send prefix hint** in the DHCPv6 client configuration before saving.

---

## CityFibre (DHCP + VLAN 911)

CityFibre needs a VLAN tag of `911` on the WAN port, untagged traffic won't get an address.

### 1. Create the VLAN

Go to **Interfaces → Other Types → VLAN** and press **+**.

```text
Parent interface: your WAN NIC
VLAN tag:          911
Description:       Olilo CityFibre
```

**Save**

### 2. Assign it as WAN

Go to **Interfaces → Assignments**, assign the new VLAN interface, and configure it:

```text
Enable Interface:        Tick
IPv4 Configuration Type: DHCP
IPv6 Configuration Type: DHCPv6

DHCPv6 client configuration
Prefix delegation size:    48
Request DNS configuration: Untick
```

**Save** and **Apply Changes**.

---

## Freedom Fibre (DHCP)

No VLAN, no PPPoE. Go to **Interfaces → [WAN]**.

```text
IPv4 Configuration Type: DHCP
IPv6 Configuration Type: DHCPv6

DHCPv6 client configuration
Prefix delegation size:    48
Request DNS configuration: Untick
```

**Save** and **Apply Changes**.

---

## LAN IPv6 (all networks)

Each internal network/VLAN should use one `/64` from your delegated `/48`. There are two ways to assign it, pick one per interface.

Olilo provides both SLAAC and DHCPv6, DHCPv6 (below) appears to be the preferred option.

**Terminology:** GUA = IPv6 Globally Unique Address, i.e. a public IP address.

### Method A: Static IPv6 (simplest)

Go to **Interfaces → [LAN]**.

```text
IPv6 Configuration Type: Static IPv6
IPv6 address:            a /64 from your /48, e.g. 2001:db8:abcd:1::1/64
```

**Save** and **Apply Changes**, then go to **Services → Router Advertisements**, select LAN, and set:

```text
Mode: Stateless
```

**Save** and **Apply**. Repeat for any other VLANs.

### Method B: Identity Association (automatic prefix assignment)

Rather than manually picking each `/64`, OPNsense can derive it automatically from the WAN's delegated prefix. This is useful if you're configuring several VLANs and want to avoid tracking hextets by hand. Make sure your WAN has **Request prefix only** and **Send prefix hint** ticked (see the note in the Openreach WAN section above).

If configuring this from scratch, it's best to test on a spare VLAN before deploying to your main network.

Go to **Interfaces → [your LAN/VLAN interface]**.

```text
IPv6 Configuration Type: Identity Association
```

A new section `IPv6 Identity Association` will appear further down the page:

```text
Parent interface: your WAN interface
Assign prefix ID: e.g. your VLAN ID, or any unique number
```

`Assign prefix ID` should be unique per interface on your network to avoid a conflict, using the VLAN ID is a convenient choice.

**Save** and **Apply Settings**.

Then go to **Services → Router Advertisements**, add/select your interface, and set:

```text
Enabled:   Tick
Interface: your LAN/VLAN interface
Mode:      Assisted
```

**Save** and **Apply**. Repeat the interface and Router Advertisement steps for each additional interface you want a GUA on.

---

## Firewall

OPNsense has a `Default allow LAN to any rule` on the default LAN firewall interface. Depending on your configuration, this may not cover IPv4+IPv6. If not, edit the rule and set:

```text
Version: IPv4+IPv6
```

**Save** and **Apply**. Repeat for any other LAN/VLAN interfaces.

---

## MSS clamping (PPPoE only)

Openreach PPPoE has an effective MTU of 1492. To avoid pages hanging or partially loading, clamp TCP MSS on client-facing rules:

```text
IPv4 MSS: 1452  (1492 MTU - 20 IP - 20 TCP)
IPv6 MSS: 1432  (1492 MTU - 40 IPv6 - 20 TCP)
```

Go to **Firewall → Settings → Normalization** and add a rule per address family, per interface, with the values above as **Max mss**. This isn't needed on CityFibre or Freedom Fibre, which don't use PPPoE.

---

## Verify

On a test device, renew your IP (disconnecting and reconnecting the network connection is arguably easiest), then check your address. You should see a GUA IPv6 address, similar to `2001:0db8:85a3:40:0000:8a2e:0370:7334/64`.

If you have a static IPv6 `/48` range, the first 3 hextets are your IP range, the 4th hextet is your prefix ID (from Method B, or the value you chose in Method A), and the last 4 hextets are your unique client address.

Go to **https://test-ipv6.com** (and/or **https://test-ipv6.run**). You should see your ISP listed as `OLILO`, with both an IPv4 and IPv6 address, and a 10/10 IPv6 score. If only IPv4 shows, double-check the DHCPv6/Prefix Delegation settings above.

---

## Final thoughts

Since GUAs are based on the IPv6 range your ISP provides, this will change if you move ISP, the same as your public IPv4 address would. GUAs should **not** replace local/LAN IP addresses, they should be used alongside them.

A DHCP reservation can be created to ensure a client receives the same GUA at each renewal, letting you build stable, secure firewall rules around it.

## Still stuck?

- **Discord:** discord.gg/olilo
- **Email:** support@olilo.co.uk

## Related guides

- Which Network Am I On?
- L2TP Guide
- IPv6 Not Working? Troubleshooting
- PPPoE Won't Connect
