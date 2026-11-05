# Nätverkstrafik

## 1. SSH-kommunikation

- **Källa:** 172.20.1.2
- **Mål:** 172.20.1.142
- **Protokoll:** SSH över TCP
- **Port:** 22
- **Riktning:** Båda riktningarna
- **Frekvens:** Cirka 70 små paket i vardera riktningen under 2,2 sekunder.
- **Användning:** Säker fjärrinloggning och krypterad kommunikation.
- **TCP/IP-lager:** Applikationslager (SSH), transportlager (TCP).
- **Belägg:** Paket 1–146, tid 0,000–2,238 sekunder.
- **Fångstfil:** `baselinje.pcap`
- **Kommando:** `tcpdump -i any -n -w baselinje.pcap`

## 2. Inkommande TCP-anslutningsförsök

- **Källa:** Flera externa IP-adresser, exempelvis 194.180.49.123, 85.217.140.40 och 64.62.197.80.
- **Mål:** 2.28.111.243
- **Protokoll:** TCP SYN
- **Portar:** 3494, 999, 4001, 24440, 3000, 8080, 2083 och 21.
- **Riktning:** Inkommande.
- **Frekvens:** Återkommande försök under cirka 94 sekunder.
- **Användning:** Försök att inleda TCP-anslutningar.
- **Bedömning:** Mönstret kan tyda på automatiserad portskanning.
- **TCP/IP-lager:** Transportlager (TCP), internetlager (IP).
- **Belägg:** Paket 147, 149, 151, 153, 163, 167, 169, 173, 187 och 203.
- **Fångstfil:** `baselinje.pcap`
- **Kommando:** `tcpdump -i any -n -w baselinje.pcap`

## 3. TCP RST/ACK

- **Källa:** 2.28.111.243
- **Mål:** Externa IP-adresser.
- **Protokoll:** TCP RST/ACK
- **Portar:** Varierande källportar på målet och tillfälliga portar hos klienterna.
- **Riktning:** Utgående svar.
- **Frekvens:** Ett svar följer nästan omedelbart efter varje visat SYN-försök.
- **Användning:** Avvisar eller återställer TCP-anslutningsförsök.
- **Bedömning:** Förenligt med stängda portar eller aktivt avvisade anslutningar.
- **TCP/IP-lager:** Transportlager (TCP), internetlager (IP).
- **Belägg:** Paket 148, 150, 152, 154, 164 och 204.
- **Fångstfil:** `baselinje.pcap`
- **Kommando:** `tcpdump -i any -n -w baselinje.pcap`

## 4. ICMP-ping

- **Källa:** Externa IP-adresser, exempelvis 13.233.225.200.
- **Mål:** 2.28.111.243
- **Protokoll:** ICMP Echo Request / Echo Reply
- **Port:** Ingen TCP- eller UDP-port används.
- **Riktning:** Båda riktningarna.
- **Frekvens:** Fem synliga förfrågningar och fem motsvarande svar.
- **Användning:** Kontrollerar IP-nåbarhet och om värden svarar.
- **TCP/IP-lager:** Internetlager (ICMP och IP).
- **Belägg:** Paket 155–160 och 197–200.
- **Fångstfil:** `baselinje.pcap`
- **Kommando:** `tcpdump -i any -n -w baselinje.pcap`

## 5. ARP-förfrågan och svar

- **Källa:** 2.28.111.243
- **Mål:** 172.31.1.1
- **Protokoll:** ARP
- **Port:** Ingen TCP- eller UDP-port används.
- **Riktning:** Lokal nätverkskommunikation i båda riktningarna.
- **Frekvens:** Två synliga förfrågningar och två svar.
- **Användning:** Hittar MAC-adressen för en IPv4-adress på det lokala nätverket.
- **Resultat:** IP-adressen 172.31.1.1 har MAC-adressen `d2:74:7f:6e:37:e3`.
- **TCP/IP-lager:** Nätverksåtkomstlager.
- **Belägg:** Paket 165–166 och 193–194.
- **Fångstfil:** `baselinje.pcap`
- **Kommando:** `tcpdump -i any -n -w baselinje.pcap`