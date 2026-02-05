# Vulnerability Mapping
*Connecting 839-byte forensic data to known CVEs.*

### 1. Resolver Flaws (2025-2026)
- **CVE-2025-40778 (BIND 9 Bailiwick Bypass):** Directly relates to the unsolicited records I caught in the PCAP.
- **CVE-2025-5994 ("Rebirthday Attack"):** Explains the race conditions and latency seen during high-traffic lab tests.

### 2. Generic Hardware Weaknesses
- **CVE-2026-0625:** A CVSS 9.3 vulnerability in legacy firmware common in off-brand repeaters.
- **CVE-2022-33989 (dproxy-nexgen):** Static UDP source ports. If entropy is low, poisoning is trivial.
