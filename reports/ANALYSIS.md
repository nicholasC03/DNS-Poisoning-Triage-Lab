# Forensic Analysis Report: Incident 2026-02-04
**Subject:** Abnormal DNS Payload & Layer 2 Routing Disruption

## 🔍 Technical Analysis
The captured traffic in `evidence/full_network_incident.pcap` reveals a multi-stage disruption originating from an unauthorized hardware node. 

### 1. Layer 2 Hijack (ARP)
The node successfully executed an ARP spoofing attack, associating the gateway IP (`192.168.1.1`) with a non-standard MAC address. This positioned the rogue hardware as the primary hop for all outbound workstation traffic.

### 2. DNS Frame Anomaly (The 839-Byte Signature)
The most significant indicator was a recurring malformed DNS response for root-level (`.`) queries. 
* **Observation:** While a standard DNS root response is typically minimal, the rogue packets were consistently **839 bytes**.
* **Impact Analysis:** Through separate simulation testing, it was confirmed that persistent injection of these malformed frames can trigger a kernel-level deprioritization (**Metric 20100**) in NetworkManager, though the initial incident was caught during the latency-degradation phase.

## ✅ Conclusion
The incident was localized to physical repeater hardware and successfully remediated via the removal of the hardware and the implementation of **DNS-over-TLS (DoT)**, which prevents unencrypted L2/L3 packet injection from reaching the resolver.
