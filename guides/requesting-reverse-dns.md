---
title: Requesting Reverse DNS (rDNS)
description: How to set a custom PTR record for your static IP
category: Advanced
author: Aydan Abrahams
lastUpdated: 11/07/2026
---

# Requesting Reverse DNS (rDNS)

Every Olilo static IP plan includes custom reverse DNS at no extra charge. This is useful for running mail servers (many providers reject mail from IPs without matching forward/reverse DNS), or just for tidiness on anything you expose publicly.

## How to request it

Reverse DNS isn't self-service yet, email **support@olilo.co.uk** with:

1. The static IP address (or block) you want it set on
2. The hostname you want it to resolve to, e.g. `mail.example.com`
3. Confirmation that you control the forward DNS for that hostname (so it actually points back to your IP)

## What to expect

Support will confirm once it's set. Test it with:

```bash
dig -x YOUR_IP_ADDRESS
```

You should see your requested hostname in the answer.

## Good practice

For it to be useful, especially for mail, make sure the forward DNS record (`mail.example.com A YOUR_IP`) matches your reverse DNS exactly. Mismatched forward/reverse is often treated as worse than no rDNS at all.

## Related guides

- CGNAT and Static IPs Explained
- L2TP Guide
