---
title: No Internet? Start Here
description: The checklist to run through before contacting support, usually fixes it in under 5 minutes
category: Troubleshooting
author: Aydan Abrahams
lastUpdated: 11/07/2026
---

# No Internet? Start Here

Work through this in order, most outages are fixed by step 2 or 3.

## 1. Check if it's a known issue

Go to **status.olilo.co.uk** on your phone (using mobile data). If there's a network-wide issue, it'll be listed there, no need to contact support, just wait it out and check back.

## 2. Power cycle in the right order

Order matters, do this one device at a time, waiting for each to fully come back before moving to the next:

1. **Unplug the ONT** (the box the fibre goes into) for 10 seconds, plug it back in, wait 2-3 minutes for its lights to settle.
2. **Then unplug your router** for 10 seconds, plug it back in, wait 1-2 minutes.

Restarting both at once, or restarting the router first, is a common reason this doesn't fix things, the ONT needs to fully reconnect to the network before your router can get an address from it.

## 3. Check your ONT's lights

Every light on your ONT tells you something different. See the specific guide for your network:

- **CityFibre ONT Guide**, Power / Broadband / Service / Ethernet lights
- **Openreach ONT Guide**, Power / PON / LOS / LAN lights

If you're on Gigaclear, MS3, or Trooli, your ONT is supplied by that network rather than Openreach, so the exact light layout may differ, the same general idea applies (a power light, a fibre/optical light, and a service/link light), but check any paperwork your installer left, or ask support if you're unsure what a light means.

If a light shows a fault state (e.g. red, or off when it should be lit), that guide tells you what to try before contacting us.

## 4. If you're on PPPoE (Openreach, Gigaclear, MS3, Trooli)

Double-check your login is entered exactly as supplied, PPPoE usernames and passwords are case-sensitive. See [PPPoE Won't Connect](./pppoe-wont-connect.md) if it's still not authenticating.

## 5. Still down?

Get in touch, and have this ready so we can help faster:

- Which lights are on/off/flashing on your ONT
- Whether you've already tried the restart above
- Any error message your router shows

- **Discord:** discord.gg/olilo, usually under 15 minutes, 09:00-17:00
- **Email:** support@olilo.co.uk, within 4 hours, 09:00-17:00

## Related guides

- Openreach ONT Guide
- PPPoE Won't Connect
- Getting Help Fast: Support Channels Explained
