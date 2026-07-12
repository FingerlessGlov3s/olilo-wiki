---
title: Understanding Your Openreach ONT
description: Guide to your Openreach Optical Network Terminal and what its lights mean
category: Setup
author: Aydan Abrahams
lastUpdated: 12/07/2026
---

# Understanding Your Openreach ONT

> This guide covers the **Openreach** ONT specifically. If you're on Gigaclear, MS3, or Trooli, your ONT is supplied by that network and may differ, see [No Internet? Start Here](./no-internet-start-here) for general guidance, or ask support.

Your ONT (Optical Network Terminal) is the small box an Openreach engineer installed where the fibre enters your property. It converts the fibre signal into standard ethernet for your router.

## Common models

Openreach has installed several ONT models over time, most commonly variants of the **Nokia G-010G-P/G-010G-T**, and the **ADTRAN SDX 611Q**. Newer XGS-PON installs (for higher speed tiers) may use different units again as Openreach rolls out 2.5G/10G-capable hardware. They all report status using the same four lights described below.

## The four lights

### Power

**Solid/flashing green**, the ONT has power and is running normally.
**Off**, no power reaching the ONT. Check it's plugged in and the socket has power.

### PON (Passive Optical Network)

This is the fibre link status.

**Solid green**, the fibre link to the exchange is up and your ONT is recognised on the network. This is what you want to see.
**Flashing**, the ONT is still authenticating/connecting to the exchange, give it a minute.

### LOS (Loss of Signal)

**Off**, normal, no problem.
**Lit (usually red)**, the optical signal has been lost. Gently check the fibre lead isn't kinked or damaged **without unplugging it**, then try one restart (see below). If LOS is still lit afterwards, this is a line fault, contact us, it isn't something you can fix at the router.

### LAN

**Solid/flashing**, normal, ethernet is connected and (when flashing) actively passing data between the ONT and your router.
**Off**, the ONT isn't seeing your router. Check the ethernet cable is firmly connected at both ends, into Port 1 on the ONT (where the engineer originally connected it), and that your router is powered on.

## What healthy looks like

- Power: solid green
- PON: solid green
- LOS: off
- LAN: flickering (when in use)

If your ONT looks like this and you still don't have internet, the issue is downstream, your router, or its configuration, see [Which Network Am I On?](./which-network-am-i-on) and the relevant router setup guide.

## How to restart

Unplug the ONT's power lead, wait about 10 seconds, plug it back in, and give it 2-3 minutes to fully come back before judging the result.

## Reset button

Some Openreach ONT models have a small reset pinhole (usually on the side or underside), press and hold with a paperclip for 10-15 seconds to factory reset. **Not every model has one**, if you can't find a reset hole, your unit likely doesn't have one, and a power cycle is the correct way to restart it. Only use a factory reset if support asks you to, it does not usually need resetting to fix a connection issue.

## Still stuck?

Before contacting us, note down:

1. Which lights are on, off, or flashing, and their colour
2. Whether you've already tried a restart
3. Whether the LOS light specifically is lit

- **Email:** support@olilo.co.uk
- **Discord:** discord.gg/olilo

## Related guides

- No Internet? Start Here
- PPPoE Won't Connect
- Which Network Am I On?
