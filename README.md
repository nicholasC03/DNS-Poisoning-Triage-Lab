# DNS Poisoning Triage & Mitigation Lab

## Overview
This repository documents a real-world DNS interception event identified within an Arch Linux environment. It serves as a technical case study in network traffic analysis and infrastructure hardening.

## The Incident: 839-Byte Anomaly
During routine network auditing, a `dig` query for Root Name Servers (`.`) returned a response size of **839 bytes**. This payload suggested a Man-in-the-Middle (MiTM) interception at the gateway level.

## Mitigation Strategy
1. **Encryption:** Migrated from UDP/53 to encrypted DNS-over-TLS using Quad9.
2. **Validation:** Configured `unbound` to perform DNSSEC validation.
3. **Isolation:** Bypassed the compromised gateway resolver entirely.
