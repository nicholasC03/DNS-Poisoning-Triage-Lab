# Analysis Report: DNS and ARP Triage Exercise

## Question

What can the provided packet-capture snippet support about the observed DNS and ARP traffic, and what remains unproven?

## Evidence available

- `evidence/incident_triage_snippet.pcap`
- `evidence/wireshark_anomoly.png` (legacy filename)
- an Unbound forwarding configuration
- a resolver-comparison script
- example post-configuration output

The repository does not currently provide a complete chain of custody, capture-interface details, exact package/firmware versions, a device inventory, or a full incident timeline. Those gaps limit attribution.

## Observations to verify in the capture

### ARP

Use the following command to enumerate ARP claims with packet numbers:

```bash
tshark -r evidence/incident_triage_snippet.pcap -Y arp \
  -T fields -e frame.number -e frame.time_relative \
  -e arp.opcode -e arp.src.proto_ipv4 -e arp.src.hw_mac \
  -e arp.dst.proto_ipv4 -e arp.dst.hw_mac
```

If two MAC addresses claim the same IPv4 address, possible explanations include spoofing, duplicate addressing, device replacement, failover, virtualization, or a synthetic lab capture. The packet sequence and environment must distinguish among them.

### DNS

Use this command to list DNS questions, responses, record counts, and frame sizes:

```bash
tshark -r evidence/incident_triage_snippet.pcap -Y dns \
  -T fields -e frame.number -e frame.time_relative \
  -e ip.src -e ip.dst -e udp.srcport -e udp.dstport \
  -e dns.id -e dns.flags.response -e dns.qry.name \
  -e dns.count.answers -e frame.len
```

A frame length of 839 bytes is not inherently malformed. DNS responses vary with the requested records, DNSSEC material, EDNS behavior, and response contents. A defensible finding must identify the relevant packet numbers and decoded records, then compare them with an equivalent baseline query.

## Initial hypotheses

The original project considered ARP spoofing, DNS injection, and a rogue network device. These remain hypotheses unless the capture and environment data demonstrate:

- conflicting IP-to-MAC mappings that are not legitimate;
- unsolicited or forged DNS records tied to a specific query and transaction;
- the identity and behavior of the suspected device;
- a repeatable relationship between the traffic and the observed system symptom.

## Configuration change

The example Unbound configuration forwards upstream DNS through authenticated TLS on TCP/853. This can improve DNS privacy and transport integrity between the local resolver and the selected upstream service.

It does not prevent ARP spoofing, remove a malicious local device, authenticate ordinary non-DNS traffic, or prove that the earlier traffic was an attack.

## Conclusion

This repository is best described as an educational traffic-triage and resolver-configuration lab. It demonstrates a review process and a narrower hardening step. Based on the published evidence alone, it should not be described as a confirmed real-world cache-poisoning incident, a hardware exploit, or exploitation of a named CVE.

## Evidence needed for a stronger conclusion

1. SHA-256 hash and `capinfos` output for the capture.
2. Exact packet numbers supporting every claim.
3. Capture interface, direction, timestamps, and collection method.
4. Resolver, router/repeater, OS, and firmware versions.
5. Known-good comparison captured under the same conditions.
6. Reproduction steps and repeated results.
7. Alternative hypotheses tested and ruled out.

