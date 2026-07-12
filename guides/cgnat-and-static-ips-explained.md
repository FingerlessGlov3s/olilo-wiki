---
title: CGNAT and Static IPs Explained
description: What CGNAT is, why it causes problems, and why every Olilo Prosumer plan includes a free static IP
category: Setup
author: Aydan Abrahams
lastUpdated: 01/07/2026
---

# CGNAT and Static IPs Explained

## What is CGNAT?

Carrier-Grade NAT (CGNAT) is when an ISP shares one public IP address across hundreds or thousands of customers, instead of giving each one their own. It's common on mobile broadband, satellite, and budget fixed-line ISPs stretching a shrinking pool of IPv4 addresses.

## Why it's a problem

Behind CGNAT you generally can't:

- Host anything that needs inbound connections, game servers, mail, cameras you access remotely, self-hosted apps
- Use port forwarding, there's no port to forward, the "public" IP isn't really yours
- Get a consistent reputation for your connection, since you're sharing an IP with strangers
- Reliably run VPN servers or other services that expect a stable, real address

## How Olilo Prosumer avoids it

This wiki covers **Olilo Prosumer** (this site, olilo.co.uk), every Prosumer plan includes a **static public IPv4 address as standard, free, no add-on required**, plus a **/48 IPv6** prefix. No CGNAT, ever, you're routed directly.

Because there's no CGNAT, you get:

- Full inbound access to your own router or devices
- Working port forwarding, no workarounds needed
- A stable address that doesn't change, useful for anything that depends on a fixed IP
- A real IPv6 /48, so every VLAN or device group can have its own subnet

## A note on Olilo Consumer

Olilo also runs a separate product, **Olilo Consumer** (consumer.olilo.co.uk), on a different network with a different contract. Consumer is CGNAT by default, with a static IP available there as a paid add-on. If you're reading this wiki you're almost certainly on **Prosumer**, where it's already included, but if you ordered from consumer.olilo.co.uk this guide's setup steps don't apply to you, see [Prosumer vs Consumer](/prosumer-vs-consumer) to check which one you're on.

## Already with another ISP and stuck behind CGNAT?

You don't need to switch broadband providers to fix this. Olilo's [L2TP service](/l2tp) tunnels a real static IPv4 and /48 IPv6 onto **any UK line**, including the one you already have, for £10/month with no setup fee. See the L2TP Guide for setup steps.

## Related guides

- L2TP Guide
- Which Network Am I On?
- Requesting Reverse DNS
