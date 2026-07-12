---
title: Which Network Am I On?
description: Quick reference for your connection type by network, and which setup guide to use
category: Setup
author: Aydan Abrahams
lastUpdated: 11/07/2026
---

# Which Network Am I On?

> This guide, and this wiki generally, covers **Olilo Prosumer** (this site, olilo.co.uk). If you signed up at consumer.olilo.co.uk, you're on the separate **Olilo Consumer** product, a different network and contract, see [Prosumer vs Consumer](/prosumer-vs-consumer) if you're not sure which one you're on.

Olilo Prosumer runs over several physical fibre networks. Your router setup depends on **which network serves your address**, not which Olilo plan you bought.

## Quick reference

| Network | Connection type | Extra config | Setup guides |
|---|---|---|---|
| CityFibre | DHCP (Automatic IP) | VLAN ID `911` on the WAN/Internet port | ASUS, UniFi, MikroTik, OPNsense, pfSense guides |
| Openreach | PPPoE | None | ASUS, UniFi, MikroTik, OPNsense, pfSense guides |
| Freedom Fibre | DHCP (Automatic IP) | None | ASUS, UniFi, MikroTik, OPNsense guides |
| Gigaclear | PPPoE | None (same process as Openreach) | Gigaclear/MS3/Trooli PPPoE guide |
| MS3 | PPPoE | None (same process as Openreach) | Gigaclear/MS3/Trooli PPPoE guide |
| Trooli | PPPoE | None (same process as Openreach) | Gigaclear/MS3/Trooli PPPoE guide |

## Not sure which one you're on?

Check the welcome email Olilo sent you when your line went live, it names the network. If you can't find it, ask in Discord or email support@olilo.co.uk.

## What "PPPoE" and "DHCP" actually mean

- **PPPoE**, your router dials in with a username and password (sent by Olilo by email) to bring the connection up, similar to old ADSL. Used on Openreach, Gigaclear, MS3, and Trooli.
- **DHCP / Automatic IP**, your router just requests an address from the network, no login needed. Used on CityFibre and Freedom Fibre.

CityFibre additionally needs a VLAN tag of **911** on the WAN side. This tells CityFibre's network which service to hand you; without it you won't get an IP at all.

## IPv6

Every network and every plan includes native IPv6 with a routed **/48** prefix. See your router's specific guide for how to enable it, or read [CGNAT and Static IPs Explained](./cgnat-and-static-ips-explained) for the bigger picture.

## Still not sure?

- **Discord:** discord.gg/olilo, usually under 15 minutes, 09:00-17:00
- **Email:** support@olilo.co.uk, within 4 hours, 09:00-17:00
