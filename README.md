# DNS Poisoning Discovery: Triage and Remediation

This lab is a breakdown of how I caught and killed a DNS poisoning event on my local network. The source was a budget WiFi repeater (Temu/off-brand) that was messing with my traffic. It wasn't just a "glitch"—it was a hardware-level compromise.

## The Problem (Triage)
I noticed weird redirects and failed resolutions. Instead of just rebooting, I pulled up Wireshark and saw the repeater was intercepting DNS queries and feeding back malicious IPs.

* **The Hardware:** Cheap IoT repeaters often run vulnerable Realtek SDKs.
* **The Exploit:** My analysis points to **CVE-2021-35395**. Even though it's a known issue, these devices ship with it unpatched.
* **The Proof:** I caught mismatched Transaction IDs (XIDs) in the packets. The repeater was trying to win the race against my actual DNS provider.

## The Fix (Remediation)
I didn't just toss the hardware; I hardened the network so the hardware *couldn't* lie to my machines anymore.

1. **Isolation:** Moved the IoT junk to a guest VLAN where it can't see my main traffic.
2. **DNS-over-TLS (DoT):** I set up a local Unbound resolver. Now, my DNS queries are wrapped in a TLS tunnel on Port 853. The repeater can't see what I'm asking, so it can't spoof the answer.
3. **DNSSEC:** Enforced cryptographic signing. If the response isn't signed, my system drops it.

## Technical Specs
* **OS:** Arch Linux (EndeavourOS)
* **Tools:** Wireshark, Splunk, Unbound, dig
* **Hardening:** DNS-over-TLS, DNSSEC, Port 853 enforcement

I'm focused on data integrity. If I can't trust the foundation (DNS), I can't trust the network. This lab proves I can find the leak and plug it.
