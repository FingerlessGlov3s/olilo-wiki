---
title: Slow Speeds? Wi-Fi vs Wired Troubleshooting
description: How to correctly test your speed, and rule out Wi-Fi before contacting support
category: Troubleshooting
author: Aydan Abrahams
lastUpdated: 11/07/2026
---

# Slow Speeds? Wi-Fi vs Wired Troubleshooting

Almost every "my broadband is slow" report turns out to be a Wi-Fi problem, not a broadband problem. Here's how to tell the difference.

## 1. Test wired, not over Wi-Fi

Connect a laptop (or any device) directly to your router with an ethernet cable, and test again. Wi-Fi speed depends on your device, distance from the router, walls, and interference from neighbouring networks, none of which is anything to do with your broadband line.

If wired speed is good but Wi-Fi is slow, that's a Wi-Fi problem, not a line problem, see the Wi-Fi tips below.

## 2. Test against the right number

Use **speedtest.olilo.co.uk**, Olilo's own speed test node, it gives the most accurate result since it doesn't cross other networks' congestion.

Check your **guaranteed speed**, not just the headline number, on your plan. Plans list both a top speed and a guaranteed minimum, e.g. a 900Mbps plan might guarantee 700Mbps. Anything at or above your guaranteed speed is working as expected, even if it's below the headline figure (headline speeds are best-effort maximums, not a promise).

## 3. Wi-Fi troubleshooting tips

If wired is fine but Wi-Fi isn't:

- Move closer to the router, or check for thick walls/floors between you and it
- Switch to the 5GHz band if your device supports it, it's faster at short range than 2.4GHz, though 2.4GHz travels further
- Check for interference, other routers nearby, microwaves, and some baby monitors can all disrupt 2.4GHz Wi-Fi
- Restart the device you're testing on, some devices cache a bad connection

## 4. High latency during uploads (bufferbloat)

If video calls stutter or gaming feels laggy while something else is uploading (backups, cloud sync), you may be seeing bufferbloat, latency spikes caused by upload traffic filling your connection's buffer. Enterprise/prosumer routers (pfSense, OPNsense, MikroTik, UniFi) can fix this with Smart Queue Management (SQM) or traffic shaping, worth looking into if this affects you regularly.

## 5. Still not right?

If wired speed consistently tests below your guaranteed speed on speedtest.olilo.co.uk, get in touch with the result attached:

- **Discord:** discord.gg/olilo
- **Email:** support@olilo.co.uk

## Related guides

- No Internet? Start Here
- Getting Help Fast: Support Channels Explained
