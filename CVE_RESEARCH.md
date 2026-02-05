# CVE Mapping & Industry Research
*Connecting 839-byte forensic data to known industry vulnerabilities.*

### 1. Modern Resolver Vulnerabilities (2025-2026)
My triage data (839-byte vs 239-byte mismatch) maps directly to these critical flaws:

* **[CVE-2025-40778](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2025-40778) (BIND 9 Bailiwick Bypass):** This is the primary suspect for the unsolicited resource record injection I caught in the PCAP.
* **[CVE-2025-5994](https://nvd.nist.gov/vuln/detail/CVE-2025-5994) ("Rebirthday Attack"):** Explains the latency spikes and "race conditions" observed in budget hardware under heavy query load.

### 2. Generic Hardware Weaknesses
Budget and off-brand repeaters often run unpatched, legacy libraries:

* **[CVE-2026-0625](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2026-0625):** A CVSS 9.3 vulnerability in legacy firmware common in generic hardware, leaving management interfaces open to DNS modification.
* **[CVE-2022-33989](https://nvd.nist.gov/vuln/detail/CVE-2022-33989) (dproxy-nexgen):** Static UDP source ports. Since these devices lack proper entropy, cache poisoning becomes significantly easier to execute.

---
**Summary of Findings:** The use of **Unbound with DNS-over-TLS (DoT)** successfully remediates these plaintext vulnerabilities by enforcing encryption and validation at the resolver level.
