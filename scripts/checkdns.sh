#!/bin/bash
# Triage Script: Detect DNS discrepancies
# Usage: ./checkdns.sh <target_domain>

TARGET=${1:-"google.com"}
LOCAL_NS=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | head -n 1)

echo "--- Triage for $TARGET ---"
echo "Local ($LOCAL_NS):" && dig @$LOCAL_NS $TARGET +short | sort
echo -e "\nSecure (1.1.1.1):" && dig @1.1.1.1 $TARGET +short | sort
echo -e "\n--- Checking for Byte Size Inconsistencies ---"
dig @$LOCAL_NS $TARGET | grep "MSG SIZE"
