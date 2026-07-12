---
title: PPPoE Won't Connect
description: Troubleshooting a failing PPPoE login on Openreach, Gigaclear, MS3, or Trooli
category: Troubleshooting
author: Aydan Abrahams
lastUpdated: 11/07/2026
---

# PPPoE Won't Connect

This applies if you're on **Openreach, Gigaclear, MS3, or Trooli**, these all authenticate with a PPPoE username and password rather than getting an address automatically. See [Which Network Am I On?](./which-network-am-i-on) if you're not sure which network you're on.

## 1. Confirm the ONT is actually up first

PPPoE can't authenticate if the ONT itself hasn't got a fibre signal yet, check its lights before touching your router's PPPoE settings.

- **On Openreach**, see the **Openreach ONT Guide**: if PON isn't solid green or LOS is lit, that's the problem, not your PPPoE config.
- **On Gigaclear, MS3, or Trooli**, your ONT is supplied by that network rather than Openreach and may look different, look for a power light and a fibre/optical or "service" light both showing normal (usually solid green), if either is off or red, that's a line issue, contact support before troubleshooting PPPoE further.

## 2. Check your credentials, carefully

- **Credentials are case-sensitive.** A capital vs lowercase letter, or a mistyped character, is the single most common cause of a PPPoE failure.
- They're supplied in your **Olilo welcome email**, copy-paste them rather than typing them out if you can.
- Make sure there's no trailing space accidentally copied in.

## 3. Check the physical connection

- The ONT's ethernet port must be connected directly to your router's WAN port, not through a switch first, if avoidable.
- Try a different ethernet cable if you have a spare.

## 4. Check your router's PPP logs

Most routers log exactly why a PPPoE session failed (wrong credentials vs no response at all vs timeout):

- **pfSense:** Status → System Logs → PPP
- **ASUS:** System Log tab (left menu)
- **UniFi:** Settings → System → System Log

A "no response" or "timeout" error usually points to a physical/ONT problem (see step 1). An "authentication failed" error points to your credentials (see step 2).

## 5. Still not connecting?

Send us your PPP log output along with your ONT's light status:

- **Discord:** discord.gg/olilo
- **Email:** support@olilo.co.uk

## Related guides

- No Internet? Start Here
- Openreach ONT Guide
- Which Network Am I On?
