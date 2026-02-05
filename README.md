# 🛡️ DNS Poisoning & Network Forensic Triage
**Incident Analysis and System Hardening Report**

[![Linux](https://img.shields.io/badge/OS-Arch_Linux-blue?logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Wireshark](https://img.shields.io/badge/Forensics-Wireshark-blue?logo=wireshark&logoColor=white)](https://www.wireshark.org/)
[![Security](https://img.shields.io/badge/Protocol-DNS--over--TLS-green)](https://quad9.net/)

---

## 📖 Executive Summary
This repository documents a real-world network forensic investigation on an Arch Linux workstation (**RioluPC**). The incident involved localized Layer 2 and Layer 3 anomalies caused by rogue repeater hardware. The project details the identification of **ARP Poisoning** and **DNS Buffer Noise**, followed by the successful implementation of **DNS-over-TLS (DoT)** to secure the environment.

---

## 🚩 Phase 1: Detection & Traffic Analysis
The investigation was initiated following intermittent DNS resolution latency. While the routing metric remained at a default **100**, forensic inspection of the traffic revealed a signature anomaly.

### Technical Indicators (IoCs):
* **839-Byte DNS Frame:** Packet analysis identified oversized, malformed DNS responses for the root zone (`.`). 
* **Payload Discrepancy:** These frames contained significant trailing "noise" bytes, totaling **839 bytes** on the wire—a departure from standard minimal DNS query/response behavior.
* **ARP Table Discrepancy:** Direct inspection of the ARP cache revealed the gateway IP (`192.168.1.1`) was being claimed by an unauthorized MAC address (`00:11:22:33:44:55`).



---

## 🔍 Phase 2: Forensic Evidence
The primary evidence of this incident is captured in the provided `.pcap` file. Analysis of this capture reveals the sequential lifecycle of the disruption:

1. **Unauthorized DHCP Offer:** Initial attempt by rogue hardware to establish a presence.
2. **ARP Hijack:** The transition of the gateway hardware address to the attacker-controlled MAC.
3. **Malformed Response:** The delivery of the 839-byte DNS response, which successfully triggered system-level deprioritization of the network link.



---

## 🛠️ Phase 3: Remediation & Hardening
The remediation strategy focused on eliminating the physical threat and encrypting the DNS transport layer to prevent future unencrypted injection.

### Security Implementation:
* **Metric Restoration:** Reset the interface priority to **100** and flushed the ARP neighbors to re-establish a trusted connection to the legitimate gateway.
* **Encrypted Transport:** Configured `systemd-resolved` to enforce **DNS-over-TLS (DoT)** using Quad9 (`9.9.9.9:853`).
* **Verification:** Validated that all outbound queries are now wrapped in TLS, rendering local packet-injection attempts (like the 839-byte noise) ineffective.



---

## 📂 Repository Structure & Contents

| Directory / File | Description |
| :--- | :--- |
| **`evidence/`** | Contains `full_network_incident.pcap` — the primary forensic capture of the 839-byte DNS anomaly and Layer 2 ARP poisoning. |
| **`reports/`** | **`ANALYSIS.md`**: A technical deep-dive into the packet headers and indicators of compromise (IoCs) found during triage. |
| **`scripts/`** | **`checkdns.sh`**: A custom Bash utility developed to automate DNS transport validation and latency monitoring post-remediation. |
| **`configs/`** | **`unbound.conf`**: The hardened local resolver configuration used to enforce secure DNS recursions. |
| **`logs/`** | **`remediation_validation.txt`**: Verified terminal output confirming the restoration of healthy routing metrics and encrypted transport. |
| **`CVE_RESEARCH.md`**| Documentation of background research into buffer-related vulnerabilities and hardware-specific DNS exploits. |

---

## 🎓 Conclusion
This triage highlights the importance of monitoring system-level network metrics as early warning indicators. By moving to a **DNS-over-TLS** architecture, the host has transitioned from a vulnerable, unencrypted posture to a hardened configuration suitable for sensitive cybersecurity research.

---
*Nicholas Comunale | 2026*
