## The Scenario: Supply Chain Vulnerability
I identified a DNS poisoning incident originating from off-brand IoT hardware (specifically, budget WiFi repeaters). While the vulnerability itself was a known issue with a recorded CVE, the hardware was shipped with these "day-one" weaknesses pre-installed. 

The ISP support wasn't aware of the flaw, but by monitoring my own network traffic, I caught the redirect. This lab covers how I isolated the hardware, confirmed the DNS spoofing, and hardened my network to ensure it couldn't happen again.
