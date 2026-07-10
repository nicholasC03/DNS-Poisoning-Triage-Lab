# DNS and ARP Traffic Triage Lab

An educational packet-analysis and resolver-hardening exercise completed on an Arch Linux workstation.

> **Scope:** This repository is a learning project. The included capture is useful for practicing DNS and ARP inspection, but it does **not** by itself prove a live cache-poisoning attack, malicious hardware, exploitation of a specific CVE, or a causal connection to a NetworkManager routing metric.

## Why I revised this project

My first write-up treated several observations as confirmed causes. That was too strong. A DNS frame being 839 bytes is not automatically malformed or malicious, and DNS-over-TLS protects DNS traffic to the configured upstream resolver—it does not stop ARP spoofing or every Layer 2/3 attack.

The revised version keeps the useful parts of the lab while separating:

1. what the supplied data shows;
2. what I initially suspected;
3. what would require more evidence;
4. what the resolver configuration actually changes.

That distinction is part of good incident work. It is better to narrow a conclusion than to claim more than the evidence supports.

## Lab goals

- Inspect DNS and ARP traffic with Wireshark and `tshark`.
- Compare local resolver results with a known public resolver without mislabeling plaintext DNS as encrypted.
- Configure Unbound to forward upstream DNS queries over authenticated TLS.
- Document limitations and alternative explanations.
- Produce steps another person can repeat.

## Environment

- Arch Linux workstation
- Wireshark / `tshark`
- BIND `dig`
- Unbound local resolver
- Cloudflare and Quad9 upstream resolvers over TCP/853

Exact package versions should be recorded when the lab is rerun. The current repository does not contain enough version metadata to attribute the traffic to a product vulnerability.

## Evidence provided

| Path | Purpose |
|---|---|
| `evidence/incident_triage_snippet.pcap` | Small packet-capture sample used for DNS/ARP inspection |
| `evidence/wireshark_anomoly.png` | Legacy screenshot filename retained for repository history; `anomaly` is the correct spelling |
| `reports/ANALYSIS.md` | Evidence-based review and limitations |
| `scripts/checkdns.sh` | Compares resolver output and clearly labels transport |
| `configs/unbound.conf` | Example Unbound forwarding configuration using DNS-over-TLS |
| `logs/remediation_validation.txt` | Example validation output with corrected conclusions |
| `CVE_RESEARCH.md` | Explains why the available evidence does not support a CVE attribution |

## Reproduce the review

### 1. Record file integrity

```bash
sha256sum evidence/incident_triage_snippet.pcap
capinfos evidence/incident_triage_snippet.pcap
```

Save the hash and capture metadata with your notes. Do not call the capture “full incident evidence”; it is a snippet.

### 2. Review ARP traffic

```bash
tshark -r evidence/incident_triage_snippet.pcap -Y arp \
  -T fields -e frame.number -e frame.time_relative \
  -e arp.opcode -e arp.src.proto_ipv4 -e arp.src.hw_mac \
  -e arp.dst.proto_ipv4 -e arp.dst.hw_mac
```

Look for repeated or conflicting IP-to-MAC claims. A conflict is a lead to investigate, not automatic proof of an attacker. Check whether the addresses are synthetic lab values, whether a device legitimately changed, and whether the timing supports the hypothesis.

### 3. Review DNS traffic

```bash
tshark -r evidence/incident_triage_snippet.pcap -Y dns \
  -T fields -e frame.number -e frame.time_relative \
  -e ip.src -e ip.dst -e udp.srcport -e udp.dstport \
  -e dns.id -e dns.flags.response -e dns.qry.name \
  -e dns.count.answers -e frame.len
```

Useful follow-up filters:

```text
dns && frame.len == 839
dns.flags.response == 1
dns.qry.name == "."
arp.duplicate-address-detected || arp.duplicate-address-frame
```

Packet size alone is not a verdict. DNS response sizes can vary because of record count, EDNS, DNSSEC, and transport behavior. Inspect the decoded records and compare them with a known-good baseline.

### 4. Compare resolvers

```bash
chmod +x scripts/checkdns.sh
./scripts/checkdns.sh example.com
```

The script labels a direct `dig @1.1.1.1` query correctly as plaintext DNS on port 53. When `kdig` is available, it also performs a separate TLS test.

### 5. Validate Unbound forwarding

Review `configs/unbound.conf`, adapt certificate paths for the local system, and validate before use:

```bash
sudo unbound-checkconf configs/unbound.conf
sudo ss -tnp | grep ':853'
dig @127.0.0.1 example.com
```

A successful query plus an established connection to TCP/853 supports the narrower conclusion that Unbound is forwarding to the configured upstream over TLS. It does not prove that an unrelated ARP or routing issue was eliminated.

## Findings and limitations

- The capture can be used to identify DNS and ARP frames and practice a structured review.
- An 839-byte DNS frame is an observation, not an indicator of compromise by itself.
- The current evidence does not identify a vulnerable BIND 9 resolver or affected version, so CVE-2025-40778 is background research rather than an incident attribution.
- Authenticated DNS-over-TLS improves confidentiality and integrity between this resolver and its upstream. It does not secure the entire local network.
- Strong attribution would require full capture provenance, device inventories, resolver/version evidence, packet-number references, timestamps, and repeatable before/after testing.

## References

- [RFC 7858 — DNS over TLS](https://www.rfc-editor.org/rfc/rfc7858)
- [RFC 8310 — DNS Privacy Usage Profiles](https://www.rfc-editor.org/rfc/rfc8310)
- [ISC advisory for CVE-2025-40778](https://kb.isc.org/docs/cve-2025-40778)
- [Wireshark display-filter reference](https://www.wireshark.org/docs/dfref/)

## Legal and privacy note

Use packet-capture and network-testing tools only on systems and networks you own or are authorized to test. Review captures for private addresses, hostnames, tokens, credentials, and personal information before publishing them.

