#!/bin/bash
# DNS Triage Tool - Automated Payload Size Auditing
# Target: Detect MiTM/Poisoning via packet size anomalies (Baseline: <512 bytes)

TARGET="."
ROUTER_IP="192.168.1.1"
THRESHOLD=512

echo "--- DNS Triage Audit Initiated ---"

# Check local gateway
SIZE=$(dig @$ROUTER_IP $TARGET NS +short +stats | grep "MSG SIZE" | awk '{print $4}')

if [ -z "$SIZE" ]; then
    echo "[!] Error: No response from $ROUTER_IP"
elif [ "$SIZE" -gt "$THRESHOLD" ]; then
    echo "[!] ALERT: Anomalous payload size detected ($SIZE bytes)."
    echo "[!] Root NS responses > 512 bytes indicate potential cache poisoning/interception."
else
    echo "[+] Normal payload size: $SIZE bytes."
fi
