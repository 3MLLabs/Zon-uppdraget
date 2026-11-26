# Korrelation paketfångst – loggar (elev-40)

**Tidsreferens: alla tider i UTC från fångsten `U8.1-scenario.pcap`, 2026-11-18.**
Loggplattform: Wazuh Discover, `wazuh-archives-*` och `wazuh-alerts-*`, Last 30 days. Kontrollerat 2026-11-26.
Underlag för teamet: kontroll av huvudfallet (elev-28). Se också `avvikelselista-elev40.md`.

## Korrelationstabell

| Steg | Nätverksbevis | Loggbevis | Tid (UTC) | Lucka |
|---|---|---|---|---|
| Felkonfiguration (ej angrepp) | Paket 5–761, 32 SYN mot loggservern tcp/1514 | Ingen | 11:12:41 – 11:15:16 | Ja. Ingen loggning. |
| 1. Skanning (T1046) | Paket 85–529, 220 portar, 22 och 80 öppna | Ingen | 11:14:18 – 11:14:29 | Ja. Ingen loggning. |
| 2. Brute force (T1110) | Paket 533 – ca 684, 17 korta SSH-sessioner | Ingen | 11:14:33 – 11:14:37 | Ja. Ingen loggning. |
| 3. Lyckad inloggning (T1078) | Paket 685, 172.20.1.104 port 48177 | `sshd[50716]: Accepted password for student from 172.20.1.104 port 48177 ssh2` · regel 5715, nivå 3 · nonce a886c6b4 | 11:14:39 (logg 11:14:41) | Nej, loggad. Men larmar inte (nivå 3). |
| 4. Lateral rörelse (T1021.004) | Paket 694–703, min server → 172.20.1.108 tcp/22 | Ingen | 11:14:44 | Ja. Ingen loggning. |
| 5. DNS-exfiltration (T1048) | Paket 706–737, min server → 185.12.64.1 udp/53, 14 namn under *.sync.telemetri-app.net | Ingen | 11:14:47 – 11:14:50 | Ja. Ingen loggning. |

## Larmade detektionerna från vecka 6?

Kontrollerat i Alerting → Alerts: inga larm när scenarioposterna lades in (26/11 13:06 svensk tid).

| Detektion (v6) | Larmade? | Varför inte |
|---|---|---|
| T1110 brute force (regel 5710/5712) | Nej | Ingen loggning: inga misslyckade inloggningar i scenariot |
| TA0008 zonöverträdelse (ZON-DROP) | Nej | Ingen loggning: inga ZON-rader från angriparen. Fel sökning: monitorn bevakar bara 10.40.7.x, scenariot använder 172.20.1.x |
| T1548.003 root-kommando | Nej | Inga auditd-rader i scenariot |
| T1562.004 brandväggen ändras | Nej | Steget finns inte i angreppet |
| Lyckad inloggning | Nej | Fel sökning: ingen monitor bevakar regel 5715 |

## Sökningar

Varje sökmetod är testad på något som finns. Därför betyder 0 träffar *ingen loggning*, inte *fel sökning*.

| # | Index | Sökning | Träffar | Slutsats |
|---|---|---|---|---|
| 1 | archives | `data.srcport:48177` | 1 | Inloggningen: regel 5715, nivå 3 |
| 2 | archives | `location:"/var/log/remote/inmatat/elev-40/scenario.log"` | 6 | Bara inloggningsposter (1 rätt, 5 falska) |
| 3 | archives | `location:"/var/log/remote/inmatat/elev-40/scenario.log" and not Accepted` | 0 | Inga loggposter för övriga steg |
| 4 | alerts | `location:*elev-40* and rule.id:(5710 or 5712)` | 34, alla 11–12/11 | Sökningen fungerar. Inget från scenariot. |
| 5 | archives | `location:*elev-40* and data.action:ZON*` | 316 | Brandväggsloggningen fungerar |
| 6 | archives | `location:*elev-40* and data.action:ZON* and data.srcip:172.20.1.104` | 0 | Inga ZON-rader från angriparen |
| 7 | archives | `location:*elev-40* and full_log:*172.20.1.2*` | 1 283 | Test: jokertecken med IP fungerar |
| 8 | archives | `location:*elev-40* and full_log:*172.20.1.108*` | 0 | Ingen loggpost för lateral rörelse |
| 9 | archives | `location:*elev-40* and full_log:*telemetri*` | 0 | Ingen loggpost för DNS-tunneln |
| 10 | archives | `location:*elev-40* and data.dstport:1514` | 0 | Ingen loggpost för felkonfigurationen |
| 11 | archives | `predecoder.timestamp:2026-11-18T11\:14* and location:*elev-40*` | 2 | Hela angreppets minut: bara 2 loggrader |

**Under angreppets minut (sökning 11):**

| Tid | Källa | Port | Bedömning |
|---|---|---|---|
| 11:14:41 | 172.20.1.104 | 48177 | Rätt. Stämmer med paket 685. |
| 11:14:42 | 172.20.1.2 | 48777 | Falsk. Fel källa och fel port. |

Tiden ensam räcker inte. Källa och port avgör.

**Fel sökningar som jag hittade och rättade:**

| Sökning | Problem | Rättad till |
|---|---|---|
| `full_log:*1514*` | 10 falska träffar: siffrorna 1514 fanns i tidsstämplar (t.ex. 08.015145) | `data.dstport:1514` |
| `predecoder.timestamp:2026-11-18T11:14*` | 0 träffar: kolonet skiljer fält och värde i DQL | `predecoder.timestamp:2026-11-18T11\:14*` |
| `full_log:*2026-11-18T11*` | 0 träffar: texten delas i småord vid - och : | `full_log:"2026-11-18T11:14"` (fras) |

## Ändringsförslag per lucka

| # | Lucka | Typ | Förslag | Rad i tidslinjen |
|---|---|---|---|---|
| 1 | Skanning | Regel | Ny monitor på ZON-IN-DROP: samma källa når ≥ 20 olika portar på 1 min. Gäller alla interna adresser, inte bara teamets fyra. | Steg 1, 11:14:18 |
| 2 | Brute force | Regel | T1110-monitorn räknar bara 5710 (konto finns inte). Lägg till 5760 (fel lösenord för riktigt konto): ≥ 5 på 5 min från samma källa. *Slutsats, ej observerat:* angriparen loggade in som student, så några försök gällde troligen ett riktigt konto. Vilka konton som provades syns inte. | Steg 2, 11:14:33 |
| 3 | Inloggning larmar inte | Regel | Ny monitor: regel 5715 när källan inte är jump (172.20.1.2) eller ctf (172.20.1.10). | Steg 3, 11:14:41 |
| 4 | Lateral rörelse | Ny källa / mätpunkt | Logga nya utgående SSH i brandväggen (`ct state new tcp dport 22 log prefix "ZON-UT-SSH "`). Skicka sshd-loggen från alla servrar till loggservern. | Steg 4, 11:14:44 |
| 5 | DNS-exfiltration | Ny källa + segmentering | Servrarna får bara fråga en intern DNS-server som loggar alla frågor. Monitor på långa eller slumpmässiga namn mot samma okända domän. | Steg 5, 11:14:47 |
| 6 | Felkonfiguration | Transport | Rätta loggklienten till 6514. Monitor: larm om en server inte har skickat loggar på 10 min. | 11:12:41 |
