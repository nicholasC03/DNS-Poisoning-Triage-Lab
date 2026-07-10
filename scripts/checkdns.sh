#!/usr/bin/env bash
# Compare DNS answers and report the transport used by each test.
# Usage: ./checkdns.sh [domain]

set -u

TARGET="${1:-example.com}"
LOCAL_NS="$(awk '/^nameserver[[:space:]]+/ {print $2; exit}' /etc/resolv.conf)"

if ! command -v dig >/dev/null 2>&1; then
    echo "Error: dig is required." >&2
    exit 1
fi

if [[ -z "${LOCAL_NS}" ]]; then
    echo "Error: no resolver was found in /etc/resolv.conf." >&2
    exit 1
fi

echo "=== DNS comparison for ${TARGET} ==="
echo
echo "Local resolver (${LOCAL_NS}; transport depends on local configuration):"
dig "@${LOCAL_NS}" "${TARGET}" A +noall +answer +stats

echo
echo "Cloudflare reference (1.1.1.1; plaintext DNS on port 53):"
dig @1.1.1.1 "${TARGET}" A +noall +answer +stats

echo
if command -v kdig >/dev/null 2>&1; then
    echo "Cloudflare DNS-over-TLS test (1.1.1.1; TLS on port 853):"
    kdig +tls @1.1.1.1 "${TARGET}" A +short
else
    echo "DNS-over-TLS query skipped: install kdig for a direct TLS query test."
    echo "A TLS handshake can be checked separately with:"
    echo "  openssl s_client -connect 1.1.1.1:853 -servername cloudflare-dns.com </dev/null"
fi

echo
echo "Note: different answers or message sizes are leads to investigate, not proof of poisoning."

