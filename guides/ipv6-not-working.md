---
title: IPv6 Not Working? Troubleshooting
description: How to check whether you have a working IPv6 address, and fix it if you don't
category: Troubleshooting
author: Aydan Abrahams
lastUpdated: 08/07/2026
---

# IPv6 Not Working? Troubleshooting

Every Olilo plan includes a routed **/48 IPv6** prefix. If you're only seeing an IPv4 address, work through this.

## 1. Test it

Go to **https://test-ipv6.com** from a device on your network. You should see:

- Your ISP shown as **OLILO**
- Both an IPv4 and an IPv6 address listed

If only IPv4 shows up, IPv6 either isn't enabled on your router, or isn't being handed out to your devices.

## 2. Check your router's IPv6 setting is actually on

IPv6 is usually a separate toggle from your main WAN setup, and it's easy to skip. Check your router's setup guide:

- ASUS: IPv6 page, Connection Type set to **Native**
- UniFi: Internet 1 panel, IPv6 Configuration set to **DHCPv6**
- MikroTik / OPNsense / pfSense: DHCPv6 client with **Prefix Delegation** requested (this is what gets you the /48, not just a single WAN address)

If you skipped the IPv6 section of your router's setup guide, that's almost always the fix.

## 3. Reconnect your device

Sometimes a device holds onto a stale "IPv6 not available" state from before you enabled it. Reconnect to Wi-Fi (or unplug/replug ethernet) on the device you're testing from, then test again.

## 4. Router shows IPv6, but devices on your LAN don't

This usually means Router Advertisements (RA) aren't enabled on your LAN/VLAN interface, so devices never receive an address. Check the Router Advertisements setting under your LAN interface (this step is called out explicitly in the OPNsense/pfSense guides).

## 5. Still stuck?

Have this ready:

- A screenshot of your router's WAN/Internet status page
- The result from test-ipv6.com

- **Discord:** discord.gg/olilo
- **Email:** support@olilo.co.uk

## Related guides

- Which Network Am I On?
- CGNAT and Static IPs Explained
- No Internet? Start Here
