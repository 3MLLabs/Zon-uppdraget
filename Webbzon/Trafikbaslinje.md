# Trafikbaslinje – webbzonen (elev-40)

Ny baslinje vecka 8 (25/11). Ersätter inte baslinjen från vecka 1, utan kompletterar den för webbservern.

| Fält | Värde |
|---|---|
| Server | elev-40, webbserver (172.20.1.140, publik 2.28.97.87) |
| Fångstfil | `baslinje-webbzon.pcap` (34 683 byte, ligger kvar på elev-40) |
| Tid | 2026-11-25, 15 minuter, klar 13:08 (serverns tid) |
| Kommando | `sudo timeout 15m tcpdump -i any -n -w baslinje-webbzon.pcap` |
| SHA-256 | `527d6b5056c23f9fd51bc4b4bf67f5b836a7f963e232f4509b5ec32b0ac57d9d` |

## 1. Vad finns?

`tshark -r baslinje-webbzon.pcap -q -z io,phs`

| Protokoll | Paket |
|---|---|
| Totalt | 202 |
| SSH | 150 |
| TLS | 12 |
| HTTP | 2 |
| NTP | 2 |
| ARP | 10 |
| DNS | 0 |

## 2. Vilka pratar? – normal trafik

`tshark -r baslinje-webbzon.pcap -T fields -e ip.src -e ip.dst -e tcp.dstport -e udp.dstport | sort | uniq -c | sort -rn`

| # | Flöde | Port | Paket | Vad | Regel |
|---|---|---|---|---|---|
| B1 | jump (172.20.1.2) ↔ elev-40 | tcp/22 | 77 + 76 | Min SSH-session för drift | D1 |
| B2 | elev-40 → loggservern (172.20.1.58) | tcp/6514 | 12 + 13 svar | Loggar över TLS | D5 |
| B3 | Internet (172.236.228.38) → publik adress | tcp/80 | 6 + 4 svar | Ett webbesök | F2 |
| B4 | Internet (83.217.174.36) → publik adress | tcp/443 | 1 + 1 svar | Ett försök mot 443. Ingen tjänst lyssnar, servern svarar RST. | F1 |
| B5 | elev-40 → tidsserver (213.239.239.166) | udp/123 | 1 + 1 svar | NTP, rätt tid | D4 |
| B6 | Lokalt nät | ARP | 10 | Servern frågar efter MAC-adresser | – |

## 3. Slutsatser

- Servern är lugn: cirka 13 paket per minut, mest min egen SSH-session.
- **Ingen DNS på 15 minuter.** Många DNS-frågor till en okänd domän är alltså en tydlig avvikelse (jämför DNS-tunneln i U8.1).
- **Loggarna går till 6514.** Försök mot 1514 är en avvikelse (felkonfigurationen i U8.1).
- **SSH kommer bara från jump.** SSH från en annan intern adress är en avvikelse.
- **Ingen SSH ut från servern.** SSH från servern till en annan maskin är en avvikelse.
- **NTP går till en enda adress, 213.239.239.166.** D4 kan göras smalare till den adressen.
- Inget försök från ctf under fångsten. ctf (D2, D9, D10) kommer bara när en labb kontrolleras.

## 4. Vad baslinjen inte visar

- Bara 15 minuter, en gång. Trafik som kommer mer sällan (dnf-uppdateringar D7, DHCP D6, ctf) finns inte med.
- Ingen trafik från klientzonen eller till appservern (F3) under fångsten.
- Innehållet i krypterade sessioner (SSH, TLS).
