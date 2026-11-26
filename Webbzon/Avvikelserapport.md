# Avvikelselista – elev-40 (U8.1)

Fångst: `U8.1-scenario.pcap` (762 paket, 74 263 byte), hämtad 24/11 med `hämta-fil U8.1`.
Verktyg: tshark 4.6.4.
**Tidsreferens: alla tider i UTC från fångsten (`tshark -t ud`), 2026-11-18.** Sekunder från fångstens start står inom parentes. Fångsten startar 11:12:39 UTC och slutar 11:15:16 UTC.
Metod: de sex frågorna i studieguiden för vecka 8.

## Roller i fångsten

| Adress | Roll |
|---|---|
| 172.20.1.140 | Min server (målet) |
| 172.20.1.104 | Angriparen |
| 172.20.1.58 | Loggservern |
| 172.20.1.108 | Annan intern maskin |
| 172.20.1.112, .113, .115, .117 | Vanliga webbesökare |

## 1. Vad finns?

`tshark -r U8.1-scenario.pcap -q -z io,phs`

| Protokoll | Paket |
|---|---|
| Totalt | 762 |
| DNS (UDP) | 36 |
| TCP | 726 |
| HTTP | 10 |
| SSH | 34 |

Cirka 680 TCP-paket har inget innehåll (bara SYN, RST och ACK). Det tyder på en skanning.

## 2. Vilka pratar?

`tshark -r U8.1-scenario.pcap -q -z conv,tcp`

| Flöde | Vad |
|---|---|
| .113 / .115 / .117 → .140 tcp/80 | Korta webbesök, 10 paket var |
| .104 → .140 många portar | Ett paket per port |
| .104 → .140 tcp/22 | Många korta SSH-sessioner, sedan en lång |
| .140 → .108 tcp/22 | Min server öppnar SSH mot en annan maskin |
| .140 → .58 tcp/1514 | Samma försök om och om igen |
| .140 → DNS | Vanliga namn och 14 konstiga namn |

## 3. Vad är normalt?

Jämfört med två baslinjer och mitt regelverk (D1–D10, F1–F3):

- **Ny baslinje för min server:** `trafikbaslinje-webbzon-elev40.md` (25/11, 15 minuter, 202 paket, rad B1–B6).
- **Teamets baslinje från vecka 1:** `Legacy filer/trafikbaslinje.md` (en teamkamrats server, 94 sekunder).

| Baslinjen | Normalt flöde | I scenariofångsten | Bedömning |
|---|---|---|---|
| B1 (ny) | SSH in bara från jump (172.20.1.2), tcp/22 | SSH från .104. Först 17 korta försök, sedan en lång session. | **Avvikelse** |
| B1 (ny) | Ingen SSH ut från servern | Servern öppnar SSH mot .108 | **Avvikelse** |
| B2 (ny) | Loggar till loggservern på tcp/6514 (TLS) | Försök mot 1514 var 5:e sekund, RST varje gång | **Avvikelse (felkonfiguration)** |
| B3 (ny) | Webb in på tcp/80, enstaka besök | Korta besök 25,7–95,4 s | Normalt |
| B4 (ny) + rad 3 (v1) | Servern svarar RST på stängda portar | RST som svar på skanningen och på 1514 | Normalt i sig |
| Rad 2 (v1) | SYN från **externa** adresser mot den **publika** adressen, enstaka portar | Skanning från en **intern** adress (.104), många portar på 11 s | **Avvikelse** |
| DNS (ny: 0 paket) | Ingen DNS på 15 minuter | Frågor om labbnamnen (ctf, jump, log) och 14 slumpmässiga namn under en okänd domän | **Avvikelse** för de 14 namnen |
| B5 (ny) | NTP till en tidsserver, udp/123 | Inte med i fångsten | – |
| B6 (ny) + rad 5 (v1) | ARP i det lokala nätet | Inte med i fångsten | – |

**Viktiga skillnader:**

- Skanning från internet är normalt brus (rad 2, vecka 1). Skanning från en **intern** adress är inte normalt.
- Min server gjorde **ingen DNS alls** på 15 minuter. 14 slumpmässiga namn till samma okända domän sticker därför ut tydligt.

**Vad baslinjerna inte kan avgöra:**

- De är korta (15 minuter och 94 sekunder). Trafik som kommer mer sällan finns inte med, till exempel dnf-uppdateringar (D7), DHCP (D6) och ctf.
- Ingen trafik från klientzonen eller till appservern (F3) fanns med.
- Innehållet i krypterade sessioner (SSH, TLS). Jag ser att sessionen var lång, inte vad angriparen gjorde.

## 4. Vad avviker?

| Tid (UTC) | Flöde | Vad som avviker | Paketnummer | Säkerhet | Bedömning |
|---|---|---|---|---|---|
| 11:12:41 – 11:15:16 (2,2 – 157,1 s) | .140 → .58 tcp/1514 | 32 SYN, exakt var 5:e sekund under hela fångsten. RST varje gång. Ett mål, en port. | 5 – 761 | Hög | Felkonfiguration |
| 11:13:04 – 11:14:14 (25,7 – 95,4 s) | .113 / .115 / .117 → .140 tcp/80 | Inget. Korta webbesök. | – | Hög | Normalt |
| 11:14:18 – 11:14:29 (99,6 – 110,6 s) | .104 → .140 många portar | SYN mot 220 portar, en gång var. Bara 22 (SSH) och 80 (webb) svarade med SYN/ACK. | 85 – 529 | Hög | Angrepp |
| 11:14:33 – 11:14:37 (114,8 – 118,5 s) | .104 → .140 tcp/22 | 17 korta SSH-sessioner på 4 sekunder | 533 – ca 684 | Hög | Angrepp |
| 11:14:39 (120,9 s, 13,7 s lång) | .104:48177 → .140 tcp/22 | En lång SSH-session, 5382 byte. Loggpost: `Accepted password for student from 172.20.1.104 port 48177` 11:14:41 UTC (nonce a886c6b4, U8.3). | 685 – | Hög | Angrepp |
| 11:14:44 (125,4 s, 0,26 s lång) | .140 → .108 tcp/22 | Min server öppnar SSH mot en annan maskin, under angriparens session | 694 – 703 | Medel–hög | Angrepp |
| 11:14:47 – 11:14:50 (128,5 – 131,9 s) | .140 → 185.12.64.1 udp/53 | 14 DNS-frågor med slumpmässiga namn under *.sync.telemetri-app.net, med sekvensnummer och base32 | 706 – 737 | Hög | Angrepp |

**Felkonfigurationen:** loggservern tar emot på 514 och 6514, inte 1514. Därför RST varje gång. En skanning träffar många portar en gång var. Det här träffar en port om och om igen.

## 5. Vad hände i tidsordning?

| Steg | Tid (UTC) | Vad | ATT&CK | Bevis (paket) | Bevis (logg) |
|---|---|---|---|---|---|
| 1 | 11:14:18 – 11:14:29 | Angriparen letar efter öppna portar och hittar 22 och 80 | T1046 Network Service Discovery | 85 – 529 | – |
| 2 | 11:14:33 – 11:14:37 | Angriparen gissar lösenord till SSH, den öppna porten han hittade | T1110 Brute Force | 533 – ca 684 | – |
| 3 | 11:14:39 | Angriparen loggar in som student | T1078 Valid Accounts | 685 (källport 48177) | `sshd[50716]: Accepted password for student from 172.20.1.104 port 48177` 11:14:41 UTC |
| 4 | 11:14:44 | Angriparen går vidare från min server till .108 | T1021 Remote Services | 694 – 703 | – |
| 5 | 11:14:47 – 11:14:50 | Angriparen skickar ut data i DNS-namn via resolvern | T1048 Exfiltration Over Alternative Protocol | 706 – 737 | – |

Hela angreppet tog 32 sekunder (11:14:18 – 11:14:50 UTC).

Alla fem stegen finns i min fångst. Ordningen kommer från tiderna i fångsten. Kontrollerat med `kontrollera U8.2` (Rätt).

## 6. Vad betyder det?

**Påverkan:**

- Angriparen kom in på min server med ett riktigt konto. Kontot och lösenordet är röjda.
- Angriparen använde min server för att nå en annan maskin (.108). Den kan också vara påverkad.
- Data lämnade nätet via DNS. Det var fyra ord i den här fångsten, men samma väg kan användas för mer data.
- Loggklienten skickar till fel port. Loggar från servern kan saknas på loggservern under angreppet.

**Mitt regelverk jämfört med scenariot:**

| Steg | Hade mitt regelverk stoppat det? |
|---|---|
| SSH in från .104 | Ja. D1 och D2 släpper bara SSH från jump och ctf. |
| SSH ut till .108 | Ja. Kedjan `ut` har ingen regel för tcp/22 ut. |
| DNS-tunneln | Nej. Frågorna går från min server till resolvern 185.12.64.1 (paket 706), som D3 tillåter. |
| Loggar till 1514 | Ja, stoppas. Men då kommer loggarna inte fram alls. |

**Nästa steg:**

1. Byt lösenordet på kontot som användes. Kontrollera vad som gjordes under sessionen (loggen, U8.3).
2. Kontrollera .108.
3. Stäng av lösenordsinloggning i SSH. Använd bara nycklar. Det stoppar brute force.
4. Rätta loggklienten till port 6514.
5. Logga och larma på DNS: långa eller slumpmässiga namn, många frågor mot samma okända domän.
6. Larma på många misslyckade SSH-försök (detektionen från vecka 6, T1110).

## Kommandon

| Vad | Kommando |
|---|---|
| Vad finns | `tshark -r U8.1-scenario.pcap -q -z io,phs` |
| Vilka pratar | `tshark -r U8.1-scenario.pcap -q -z conv,tcp` |
| SYN per källa, mål och port | `tshark -r U8.1-scenario.pcap -Y "tcp.flags.syn==1 && tcp.flags.ack==0" -T fields -e ip.src -e ip.dst -e tcp.dstport \| sort \| uniq -c \| sort -rn` |
| Takten mot 1514 | `tshark -r U8.1-scenario.pcap -Y "tcp.dstport==1514 && tcp.flags.syn==1 && tcp.flags.ack==0" -T fields -e frame.number -e frame.time_relative` |
| Skanningens start och slut | `tshark -r U8.1-scenario.pcap -Y "ip.src==172.20.1.104 && tcp.flags.syn==1 && tcp.flags.ack==0 && tcp.dstport!=22" -T fields -e frame.number -e frame.time_relative \| sed -n '1p;$p'` |
| Hoppet till .108 | `tshark -r U8.1-scenario.pcap -Y "ip.addr==172.20.1.108" -T fields -e frame.number -e frame.time_relative -e ip.src -e ip.dst -e tcp.dstport` |
| Antal skannade portar | `tshark -r U8.1-scenario.pcap -Y "ip.src==172.20.1.104 && tcp.flags.syn==1 && tcp.flags.ack==0" -T fields -e tcp.dstport \| sort -u \| wc -l` |
| Öppna portar (SYN/ACK) | `tshark -r U8.1-scenario.pcap -Y "ip.src==172.20.1.140 && ip.dst==172.20.1.104 && tcp.flags.syn==1 && tcp.flags.ack==1" -T fields -e tcp.srcport \| sort -nu` |
| Nyckelpaket i UTC | `tshark -r U8.1-scenario.pcap -t ud -Y "frame.number in {5,85,529,685,694,706,737}" -T fields -e frame.number -e _ws.col.Time -e ip.src -e ip.dst -e tcp.dstport -e udp.dstport` |
| Lyckad inloggning | `tshark -r U8.1-scenario.pcap -t ud -Y "tcp.srcport==48177 && tcp.flags.syn==1 && tcp.flags.ack==0" -T fields -e frame.number -e _ws.col.Time -e ip.src -e tcp.srcport` |
| Loggposten (Wazuh Discover) | `wazuh-archives-*`, Last 30 days, `data.srcport:48177` |
| DNS-frågor | `tshark -r U8.1-scenario.pcap -Y "dns.flags.response==0" -T fields -e frame.number -e dns.qry.name` |
