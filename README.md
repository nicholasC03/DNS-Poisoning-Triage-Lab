# DNS Poisoning Triage & Mitigation Lab

## 📂 Repository Structure
- **/scripts**: Automation tools for detecting DNS anomalies.
- **/reports**: Formal forensic analysis and mitigation documentation.
- **/logs**: Raw forensic telemetry and validation evidence.

## 🚨 Incident Overview: The 839-Byte Anomaly
This lab documents the detection of a 839-byte DNS payload (baseline <512b) indicating a Man-in-the-Middle (MiTM) interception at the gateway level.

## 🛠️ Mitigation
- Deployed **Unbound** with **DNS-over-TLS (DoT)** and **DNSSEC** validation.
- Configured "Deny by Default" posture to bypass compromised local resolvers.
