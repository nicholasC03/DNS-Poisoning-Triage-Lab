# DNS Poisoning Triage Lab
*Forensics and Remediation for Legacy Hardware Flaws*

## The Incident
I noticed some weird redirects while using budget Wi-Fi repeaters in my lab. Instead of just resetting them, I treated it as a triage exercise to find the "smoking gun" for DNS cache poisoning.

## Forensic Evidence (PCAP Analysis)
The key finding was a significant byte-count discrepancy in DNS responses:
- **Clean Response:** ~239 bytes
- **Poisoned/Injected Response:** ~839 bytes

This 839-byte signature confirmed that the resolver was accepting unsolicited resource records, likely via a **Bailiwick Bypass**.

## Tools & Hardening
- **scripts/checkdns.sh:** A quick triage script I wrote to compare local responses against 1.1.1.1.
- **configs/unbound.conf:** My Arch Linux Unbound setup. It uses DNS-over-TLS (DoT) to secure the "last mile" and ignore the repeater's untrusted DNS proxy.
