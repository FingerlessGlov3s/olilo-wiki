---
title: pfSense Setup Guide
description: Guide on how to set up pfSense for use with Olilo over Openreach, CityFibre, or Freedom Fibre
category: Setup
author: Ed Nevard, Aydan Abrahams
lastUpdated: 12/07/2026
---

# Introduction

This guide explains how to configure **pfSense** for use with **Olilo**, covering **Openreach FTTP** (PPPoE), **CityFibre** (DHCP + VLAN 911), and **Freedom Fibre** (plain DHCP).

Check [Which Network Am I On?](./which-network-am-i-on) first, the WAN configuration differs by network.

It assumes:

- You can access the pfSense web interface.
- Your pfSense WAN port is connected directly to your ONT.
- If you're on Openreach, you have received your PPPoE username and password from Olilo. CityFibre and Freedom Fibre don't need credentials, they use DHCP.

The examples below are based on **pfSense 2.8.1-RELEASE**, but the general process should be similar on nearby versions.

> **Note:** All IPv6 addresses in this guide use documentation/example prefixes such as `2001:db8::/32`. Replace these with the routed prefix supplied by Olilo. Do not publish your real WAN IPv6 address or customer prefix unless you are happy for it to be public.

---

# Physical Setup

```text
Openreach / CityFibre / Freedom Fibre ONT → pfSense WAN
pfSense LAN → switch / access point / internal network
```

---

# WAN Setup

## Openreach (PPPoE)

Go to:

```text
Interfaces → WAN
```

### IPv4 Configuration

Set:

```text
IPv4 Configuration Type: PPPoE
```

Enter the PPPoE details supplied by Olilo:

```text
Username: your Olilo PPPoE username
Password: your Olilo PPPoE password
```

The username and password are usually supplied by email.

### IPv6 Configuration

Set:

```text
IPv6 Configuration Type: SLAAC
```

If you are using Openreach via PPPoE, also enable:

```text
Use IPv4 connectivity as parent interface
```

This allows IPv6 to work correctly over the PPPoE session.

Save and apply the changes.

### PPPoE Driver Note

pfSense includes an option under:

```text
System → Advanced → Networking
```

called:

```text
Use if_pppoe kernel module for PPPoE client
```

This enables the newer kernel PPPoE driver.

On some systems this may improve performance, especially at higher speeds, but it may not work reliably on all setups. If the connection does not come up reliably after reboot, leave this option disabled and use the default/legacy PPPoE client.

For a typical Openreach 220/30 or 1000/115 service, the default PPPoE client is usually fine on reasonable hardware.

## CityFibre (DHCP + VLAN 911)

CityFibre requires your WAN traffic tagged with **VLAN 911**, untagged traffic won't get an address at all.

### 1. Create the VLAN

Go to:

```text
Interfaces → Assignments → VLANs
```

Press **+** and set:

```text
Parent Interface: your WAN NIC
VLAN Tag:          911
Description:       Olilo CityFibre
```

**Save**

### 2. Assign it and set it to DHCP

Go to **Interfaces → Assignments**, assign the new VLAN interface, then edit it:

```text
Enable interface:        Tick
IPv4 Configuration Type: DHCP
IPv6 Configuration Type: DHCPv6

DHCPv6 client configuration
Send IPv6 prefix hint: 48
```

**Save** and **Apply Changes**.

## Freedom Fibre (DHCP)

No VLAN tag needed. Go to:

```text
Interfaces → WAN
```

Set:

```text
IPv4 Configuration Type: DHCP
IPv6 Configuration Type: DHCPv6

DHCPv6 client configuration
Send IPv6 prefix hint: 48
```

**Save** and **Apply Changes**.

---

# Confirm WAN Connectivity

After applying the WAN settings, go to:

```text
Status → Interfaces
```

You should see a public IPv4 address (or your routed/static IPv4 configuration) and a global IPv6 address on WAN. For example, on Openreach:

```text
WAN IPv6: 2001:db8:feed:1234:....
Routed /48: 2001:db8:1234::/48
```

Do not assume the WAN IPv6 address is the same as your routed customer `/48` prefix. If unsure, ask Olilo to confirm your routed IPv6 block.

---

# LAN IPv6 Setup

Olilo may provide a routed IPv6 prefix, for example:

```text
2001:db8:1234::/48
```

Each internal network/VLAN should use one `/64`.

For example:

```text
Main LAN: 2001:db8:1234:0::/64
IoT:      2001:db8:1234:2::/64
Guest:    2001:db8:1234:3::/64
```

Go to:

```text
Interfaces → LAN
```

Set:

```text
IPv6 Configuration Type: Static IPv6
IPv6 Address: 2001:db8:1234::1
Prefix Length: 64
```

This gives the LAN interface:

```text
2001:db8:1234:0::1/64
```

For additional VLANs, use a different fourth hextet, for example:

```text
IoT VLAN:   2001:db8:1234:2::1/64
Guest VLAN: 2001:db8:1234:3::1/64
```

This applies the same regardless of which network you're on, CityFibre and Freedom Fibre use the same LAN IPv6 addressing pattern as Openreach.

---

# Router Advertisements

IPv6 clients need Router Advertisements to automatically configure addresses.

Go to:

```text
Services → Router Advertisements
```

Select the relevant interface, such as LAN.

Set:

```text
Router Mode: Unmanaged
```

This allows clients to use SLAAC.

Repeat this for each IPv6-enabled LAN/VLAN interface.

Clients should then receive global IPv6 addresses such as:

```text
2001:db8:1234:0:....
```

It is normal for clients to have more than one global IPv6 address. Usually one is stable and another is temporary/privacy-based.

---

# Firewall Rules for IPv6

pfSense blocks unsolicited inbound traffic by default, including IPv6.

For LAN/VLAN outbound access, make sure your internal interface rules allow IPv6.

Go to:

```text
Firewall → Rules → LAN
```

Ensure your allow rule is set to:

```text
Address Family: IPv4+IPv6
Protocol: Any
Source: LAN net
Destination: Any
```

Repeat for any VLANs that should have internet access.

---

# WAN ICMPv6 Rules

ICMPv6 is important for IPv6 to work properly. In particular, Path MTU Discovery relies on ICMPv6.

On WAN, create a rule for your routed IPv6 block.

Go to:

```text
Firewall → Rules → WAN
```

Add a rule:

```text
Action: Pass
Address Family: IPv6
Protocol: ICMPv6
Source: Any
Destination: your routed /48
```

For example:

```text
Destination: 2001:db8:1234::/48
```

Allow these ICMPv6 types:

```text
Destination Unreachable
Packet Too Big
Time Exceeded
Parameter Problem
```

This helps IPv6 work correctly for LAN and VLAN clients.

If you want to monitor or ping the pfSense WAN interface itself, create a separate WAN rule:

```text
Action: Pass
Address Family: IPv6
Protocol: ICMPv6
Source: Any
Destination: WAN address
Type: Echo Request
```

Echo Reply may also be allowed if desired.

---

# MSS Clamping (Openreach PPPoE only)

Openreach PPPoE uses an effective MTU of 1492.

For IPv6 over PPPoE, TCP MSS should usually be clamped to:

```text
1432
```

This is calculated as:

```text
1492 MTU - 40 IPv6 header - 20 TCP header = 1432 MSS
```

Without MSS clamping, some IPv6-enabled services may partially load, hang, or stall during TLS connections.

Apply MSS clamping on each client-facing LAN/VLAN rule.

Go to:

```text
Firewall → Rules → LAN
```

Edit the main allow rule and find the advanced options.

Set:

```text
Maximum MSS: 1432
```

Repeat this on other client-facing interfaces, such as:

```text
LAN
IoT
Guest
Servers
Management
```

Do not change WAN MTU unless Olilo specifically advises you to.

This isn't needed on CityFibre or Freedom Fibre, which don't use PPPoE and run the standard 1500 MTU.

---

# Optional: Upload Bufferbloat Fix with Limiters

On lower upload tiers such as 30 Mbps, uploads can easily cause high latency. pfSense limiters with FQ-CoDel can reduce this significantly.

Go to:

```text
Firewall → Traffic Shaper → Limiters
```

Create an upload limiter:

```text
Name: WAN_UP
Bandwidth: 27 Mbit/s
Scheduler: FQ_CODEL
Queue Management Algorithm: Tail Drop
Queue Length: 1000
```

Then add a child queue under it:

```text
Name: WAN_UP_Q
Queue Management Algorithm: Tail Drop
```

If pfSense requires both an In and Out pipe, create a dummy download limiter:

```text
Name: WAN_DOWN_DUMMY
Bandwidth: 1000 Mbit/s
Scheduler: FQ_CODEL
Queue Management Algorithm: Tail Drop
Queue Length: 1000
```

Add a child queue:

```text
Name: WAN_DOWN_DUMMY_Q
Queue Management Algorithm: Tail Drop
```

Then apply these to each client-facing LAN/VLAN rule:

```text
In pipe:  WAN_DOWN_DUMMY_Q
Out pipe: WAN_UP_Q
```

For a 220/30 service, start with:

```text
Upload limiter: 27 Mbit/s
```

Then test using a bufferbloat test. If upload latency is still high, reduce slightly. If upload speed is too low and latency is good, increase slightly.

For most users, shaping upload only is enough. Download shaping may reduce headline download speed and can interfere with bursty traffic such as YouTube buffering.

---

# DNS Settings

Go to:

```text
System → General Setup
```

Add DNS servers if desired.

Example Cloudflare:

```text
1.1.1.1
1.0.0.1
2606:4700:4700::1111
2606:4700:4700::1001
```

Example Quad9:

```text
9.9.9.9
149.112.112.112
2620:fe::fe
2620:fe::9
```

Recommended:

```text
DNS Server Override: Disabled
```

This prevents dynamically supplied DNS servers from replacing your chosen DNS servers.

If using the pfSense DNS Resolver:

```text
Services → DNS Resolver
```

Typical recommended options:

```text
Enable DNS Resolver: Enabled
Prefetch Support: Enabled
Serve Expired: Enabled
```

DNSSEC is optional.

---

# Testing

From pfSense:

```text
Diagnostics → Ping
```

Test IPv4:

```text
1.1.1.1
8.8.8.8
```

Test IPv6:

```text
2606:4700:4700::1111
2620:fe::fe
```

From a client:

```bash
ping -4 google.com
ping -6 google.com
curl -6 https://portal.azure.com
```

You can also check IPv6 using:

```text
https://test-ipv6.com
```

---

# Troubleshooting

## PPPoE does not connect (Openreach)

Check:

- PPPoE username and password.
- WAN interface is connected to the ONT.
- ONT is powered and showing service.
- PPP logs under:

```text
Status → System Logs → PPP
```

## WAN doesn't get an IPv4 address (CityFibre)

Almost always a missing or wrong VLAN tag. Confirm the VLAN is tagged **911** and assigned as the actual WAN interface, not left unassigned.

## WAN doesn't get an IPv4 address (Freedom Fibre)

Check the ONT is showing a healthy fibre/service light, and that the WAN cable runs directly into pfSense's WAN port without an intermediate unmanaged switch dropping the link.

## IPv6 works on pfSense but not on LAN clients

Check:

- LAN interface has a static IPv6 `/64` from your routed block.
- Router Advertisements are enabled.
- LAN firewall rule allows IPv6.
- The correct routed `/48` is being used.

Do not assume the WAN IPv6 prefix is your routed LAN prefix.

## Clients get IPv6 addresses but cannot reach the IPv6 internet

From pfSense, try pinging an IPv6 address using the LAN source address.

If WAN source works but LAN source fails, the LAN prefix may be wrong or not routed correctly.

Ask Olilo to confirm your routed IPv6 prefix.

## Some IPv6 websites hang or partially load

This is often an MTU/MSS issue on PPPoE.

Check:

- MSS clamp is set to `1432` on all client-facing LAN/VLAN rules.
- ICMPv6 Packet Too Big is allowed to your routed `/48`.
- WAN MTU has not been manually changed incorrectly.

## YouTube or media apps buffer

Check:

- The device's VLAN also has MSS clamp set to `1432` (Openreach only).
- Upload limiter is not accidentally shaping download too aggressively.
- If using limiters, use a dummy/no-op download queue unless download bufferbloat is actually a problem.

## Gateway monitor shows IPv6 packet loss

The automatically selected IPv6 gateway may not respond to ICMP.

Set a custom monitor IP under:

```text
System → Routing → Gateways
```

For example:

```text
2606:4700:4700::1111
2620:fe::fe
```

---

# Recommended Final Configuration

For Openreach FTTP via Olilo, a good working baseline is:

```text
WAN IPv4: PPPoE
WAN IPv6: SLAAC
Use IPv4 connectivity as parent interface: Enabled
LAN IPv6: Static /64 from routed /48
Router Advertisements: Unmanaged
MSS clamp: 1432 on all client-facing LAN/VLAN rules
WAN ICMPv6: allow essential types to routed /48
Upload shaping: optional, FQ-CoDel limiter around 90-95% of upload
Download shaping: usually not needed
```

For CityFibre and Freedom Fibre, the WAN section differs (DHCP/DHCPv6, VLAN 911 on CityFibre only) and MSS clamping isn't required, everything else above is unchanged.

---

# Backup Configuration

Once everything is working, back up your pfSense configuration:

```text
Diagnostics → Backup & Restore → Download configuration
```

Keep this backup somewhere safe.

---

# Still Stuck?

Before asking for help, gather:

1. Screenshot of `Status → Interfaces`.
2. Screenshot of WAN and LAN interface settings.
3. Your routed IPv6 prefix, if known.
4. Which network you're on, Openreach, CityFibre, or Freedom Fibre.
5. Output of IPv4 and IPv6 ping tests.
6. PPP logs if PPPoE is not connecting.

Then ask in the Olilo Discord:

```text
Discord: discord.gg/olilo
```

## Related guides

- Which Network Am I On?
- IPv6 Not Working? Troubleshooting
