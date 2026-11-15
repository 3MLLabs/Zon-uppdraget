# AI-användning vecka 44 (26 okt–1 nov 2026)

## Logg

| Datum | Moment | Min fråga | AI förklarade | Egen insats |
| --- | --- | --- | --- | --- |
| 2026-11-01 | Ö1–Ö10 | Granska en klasskamrats svar mot facit | Jämförde svaren med frågornas exakta lydelse | Ifrågasatte AI:s bedömning tills den stämde |
| 2026-10-30 | Workshop 2, förövning | Hur skriver jag testskriptet? | while read-loop, if-satser, nc -z | Byggde skriptet själv steg för steg med felsökningshjälp |
| 2026-10-30 | Vecka 4, Föreläsning 7 | Tre sätt att inte komma fram | Tyst drop, reject och att tjänsten nekar | Gjorde quiz och ställde följdfrågor |
| 2026-10-30 | Vecka 4, Föreläsning 6 | Flödestabell till regelverk | Molnbrandvägg vs värdbrandvägg, jämfört med AWS | Valde att styra båda brandväggarna manuellt |
| 2026-10-30 | Vecka 4, Föreläsning 5 | Paketfiltrets logg till loggservern | Kedjan nftables → journald → rsyslog → loggserver | Gjorde quiz (5/8) och gick igenom felen |
| 2026-10-30 | Vecka 4, Föreläsning 3 | nftables: tabeller, kedjor, handles | Ordning, policy och säker laddning | Ställde följdfrågor om handles |
| 2026-10-30 | Molnbrandväggen | Lär mig föreläsningen om Hetzner | Standard in/ut, stateful, vad den inte ser | Läste genomgången |
| 2026-10-29 | Privata nät | Nät, subnät och gateway | eth1/eth2 kräver värdbrandvägg | Delade min regeluppsättning och motiverade mina val |
| 2026-10-29 | U4.2 | Brandväggslogg till loggserver | log-regel sist, kern.\*, omfwd, regel D5 | Gjorde quiz (5/7) |
| 2026-10-29 | Ö10 m.fl. | DROP vs REJECT, nft -f vs restart | ICMP-koder och atomisk laddning | Skrev svaren själv, AI granskade |
| 2026-10-29 | Boiler Room CTF | Varför ger min SQL-injektion syntaxfel? | Ett extra citattecken bröt frågan | Rättade och klarade uppgiften |
| 2026-10-29 | nftables | Hur läser jag räknare? | nft list ruleset; nollställs vid omladdning | Testade på servern |
| 2026-10-28 | Vecka 4, RFC 1918 | Privata adresser och /-notation | Bitblock och omvandling binärt–decimalt | Räknade övningar själv |
| 2026-10-28 | Zonuppdraget, flödesplan | Bygga flödesplan för fyra zoner | Regler D7 och F4, ct state | Bad AI hålla sig till uppgiften |
| 2026-10-28 | U4.4 | Syntax för moln brandvägg | Citattecken, standardregler, NTP ut | Testade DNS, NTP och dnf själv |
| 2026-10-28 | Zonuppdraget, brandvägg | Regelverk för fyra zoner | Skrev flödestabell och nftables-filer per server | Tidspress i teamet: använde AI:s version som förlaga och bakåtkonstruerade reglerna tills jag förstod dem; laddade, testade och felsökte själv |
| 2026-10-28 | Zonuppdraget | Flödestabell till brandväggsregel, F- vs D-regler | Hetzner Cloud Firewall vs nftables på värden | Kopplade till vår zonmodell |
| 2026-10-28 | Ö7 | Granska mitt svar om TCP-mönster | Saknade returkoder, rättade beskrivningar | Mitt svar, AI skrev om |
| 2026-10-28 | nftables | Syntaxkontroll och kommentarer | nft -c; rättade p saddr till ip saddr | Skrev regeln själv |
| 2026-10-27 | U4.1 | Default deny som överlever omstart | Steg för steg, hooks och conntrack | Genomförde labben och skrev egen redovisning |
| 2026-10-27 | U4.3 | tshark-filter, klassificera portförsök | ICMP saknar portnummer | Klassificerade paketen och hittade flaggan själv |
| 2026-10-27 | U4.2 | rsyslog-vidarebefordran | Gav kommandon, sedan förklaring med liknelser | Lämnade in och lärde mig i efterhand |
| 2026-10-27 | Teamets nät | moln-kommandon och fel adress | Bara adressen var fel, inte nätet | Ifrågasatte förslaget att riva nätet |
| 2026-10-27 | Kursmål 11 | Hitta inlämningen i Canvas | Hittade uppgiften och olika deadlines | Fick underlag att fråga läraren |
| 2026-10-27 | Ö1–Ö10 | Policy drop vs drop-regel, ct state | Regelordning, persistens, reserverade adresser | Skrev svaren, AI granskade |
| 2026-10-27 | Lärarens skript | Hur fungerar exec 3<>/dev/tcp? | Öppnar en TCP-anslutning som fil | Gick igenom skriptet rad för rad |
| 2026-10-26 | U4.1 | Vad kräver labben? | Sammanställde studieguiden för vecka 4 | Läste och ställde frågor |
| 2026-10-26 | Brandväggsgrunder | -A INPUT, kedjor, nftables.conf | iptables jämfört med nftables | Förklarade tillbaka med egna ord |
| 2026-10-26 | Nätverksgrunder | NIC och lager 3-separation | Lager 2 och 3, jump host | Ställde följdfrågor |

AI användes som stöd för förklaringar, felsökning och språkgranskning. Uppgifterna skrevs, kördes och testades av mig i labbmiljön.

## Så använder jag AI

- **Fördjupning av föreläsningar:** de inspelade föreläsningarna går inte tillräckligt djupt, så jag använder AI för en grundligare genomgång av samma material, med kontrollfrågor och quiz.
- **Felsökning:** när något inte fungerar i labbmiljön frågar jag om möjliga orsaker och testar själv på servern.
- **Granskning:** jag skriver egna svar och låter AI granska tekniska detaljer och språk.
- **Undantag denna vecka:** på grund av tidspress i teamet utgick jag från AI:s nftables-regler och bakåtkonstruerade dem tills jag förstod varje regel. Jag planerar att bygga om min servers regelverk från grunden utan förlaga.
