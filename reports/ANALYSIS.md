# Forensic Analysis: DNS Payload Anomaly (Case 020226)

## Executive Summary
During a routine network audit on an Arch Linux environment, I identified a consistent DNS interception event. The local gateway (192.168.1.1) was found to be injecting non-standard data into Root NS queries, resulting in a payload size of **839 bytes**—significantly higher than the baseline 239-500 bytes.

## Technical Findings
* **The Anomaly:** Standard `dig . NS` queries returned a bloated response. 
* **The Indicator:** `MSG SIZE rcvd: 839` consistently appeared when querying the router.
* **The Root Cause:** Traffic was being intercepted by the local gateway. This behavior is consistent with DNS Cache Poisoning (correlated with CVE-2026-0625).
