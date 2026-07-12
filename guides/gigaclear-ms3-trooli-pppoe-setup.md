---
title: "Gigaclear, MS3 and Trooli: PPPoE Setup"
description: Setting up your router on the Gigaclear, MS3, or Trooli networks
category: Setup
author: Aydan Abrahams
lastUpdated: 05/07/2026
---

# Gigaclear, MS3 and Trooli: PPPoE Setup

> **A note on this guide:** Gigaclear, MS3, and Trooli all authenticate the same way as Openreach, plain PPPoE, no VLAN tagging, credentials emailed after you order. This guide assumes the router-side setup is identical to Openreach. If you hit something that doesn't match (a VLAN requirement, a different MTU, anything odd), please tell support so we can update this and the network-specific guides properly.

## What you need

Your PPPoE **username and password**, sent by email after your order goes live. These are case-sensitive, copy-paste them rather than typing them out where you can.

## Setting it up

Follow the **Openreach** instructions in whichever router guide matches yours, the WAN configuration step is the same:

- **ASUS Router Setup Guide**, Openreach section
- **UniFi Network Setup Guide**, Openreach section
- **MikroTik Internet Setup Guide**, Openreach section
- **OPNsense Internet Setup Guide**, Openreach section
- **pfSense Setup Guide**, Openreach section

In each case: set your WAN connection type to **PPPoE**, enter your username and password, leave everything else default, no VLAN tag is needed.

## IPv6

Same as Openreach, enable DHCPv6 with Prefix Delegation (or "Native"/"DHCPv6" depending on your router) to receive your routed /48. See the IPv6 section of your router's guide.

## Not connecting?

See [PPPoE Won't Connect](./pppoe-wont-connect.md), most issues are either a mistyped credential or the ONT itself not having a fibre signal yet.

## Related guides

- Which Network Am I On?
- PPPoE Won't Connect
- No Internet? Start Here
