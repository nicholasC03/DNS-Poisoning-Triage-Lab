# CVE Research and Attribution Limits

## Why a packet size cannot identify a CVE

A CVE maps to a specific vulnerable product, version range, and behavior. Matching a frame length or a general symptom is not enough. Before connecting a capture to a vulnerability, an investigation should establish:

1. the product and exact version in the traffic path;
2. whether that version is affected;
3. whether the vulnerability's prerequisites exist;
4. packet- or log-level evidence of the described behavior;
5. a repeatable test or additional evidence that rules out ordinary explanations.

## CVE-2025-40778

[ISC's advisory](https://kb.isc.org/docs/cve-2025-40778) describes cache-poisoning risk in affected **BIND 9** resolver versions under certain conditions involving acceptance of records from answers.

The published files in this repository do not identify an affected BIND 9 resolver or show its version. The provided hardening example uses Unbound as a local forwarder. Therefore, CVE-2025-40778 may be useful background reading, but it is **not an established explanation for this capture**.

## DNS-over-TLS and vulnerability remediation

DNS-over-TLS encrypts and authenticates DNS transport between a client/forwarder and its configured upstream resolver. It does not patch a vulnerable resolver implementation, prove that a prior response was forged, or prevent unrelated Layer 2 attacks.

The accurate conclusion for this lab is:

> The Unbound configuration changes upstream DNS transport from plaintext DNS to authenticated TLS. No claim is made that this configuration remediates a specific CVE or secures all local-network traffic.

## References

- [ISC: CVE-2025-40778](https://kb.isc.org/docs/cve-2025-40778)
- [RFC 7858: Specification for DNS over TLS](https://www.rfc-editor.org/rfc/rfc7858)
- [RFC 8310: Usage Profiles for DNS over TLS and DNS over DTLS](https://www.rfc-editor.org/rfc/rfc8310)

