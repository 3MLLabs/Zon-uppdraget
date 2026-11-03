# Flödestabell – team 7

Adressplanen för nätet team-7-mössorna (10.40.7.0/24).
Allt som inte står här nekas av default deny, i både inkommande och utgående riktning.

## Zoner och adresser

| Zon | Subnät | Server | Ansvarig |
|---|---|---|---|
| Klient | 10.40.7.0/26 | 10.40.7.2 | Sűstler |
| Webb | 10.40.7.64/29 | 10.40.7.66 | Martin |
| Databas | 10.40.7.72/29 | 10.40.7.73 | Victor |
| App | 10.40.7.88/29 | 10.40.7.89 | Erik |

Alla subnät har gateway 10.40.7.1. Trafiken mellan zonerna går genom Hetzners
virtuella router, som inte filtrerar och som molnbrandväggen inte ser.
Zonseparationen görs därför med nftables på varje värd.

## F-regler – flöden mellan zoner

Riktningen anges sett från målservern. Varje F-rad blir två nft-regler med samma id:
**in** på målservern och **ut** på källservern.

| Id | Riktning | Källa | Mål | Proto/port | Beslut | Motivering |
|---|---|---|---|---|---|---|
| F1 | in | Klient 10.40.7.2 | Webb 10.40.7.66 | tcp/443 | tillåt | Användarna når webbtjänsten krypterat |
| F2 | in | Klient 10.40.7.2 | Webb 10.40.7.66 | tcp/80 | tillåt | Omdirigering till HTTPS |
| F3 | in | Webb 10.40.7.66 | App 10.40.7.89 | tcp/8080 | tillåt | Webbservern anropar applikationen; bara webbzonen behöver nå appen |
| F4 | in | App 10.40.7.89 | Databas 10.40.7.73 | tcp/5432 | tillåt | Bara applikationen ska läsa och skriva data; databasen är den känsligaste tillgången |

## D-regler – driftflöden (samma på alla servrar)

| Id | Riktning | Källa | Mål | Proto/port | Beslut | Motivering |
|---|---|---|---|---|---|---|
| D1 | in | jump 172.20.1.2 | min server | tcp/22 | tillåt | All inloggning går via jump |
| D2 | in | ctf 172.20.1.10 | min server | tcp/22 | tillåt | Kursens kontrolltjänst för CTF-labbarna |
| D3 | ut | min server | 185.12.64.1, 185.12.64.2 | tcp+udp/53 | tillåt | DNS-uppslag |
| D4 | ut | min server | internet | udp/123 | tillåt | Tidssynk (NTP), krävs för spårbara loggar |
| D5 | ut | min server | log 172.20.1.58 | tcp/514 | tillåt | Loggar till den gemensamma loggservern |
| D6 | ut | min server (udp/68) | DHCP (udp/67) | udp | tillåt | DHCP-förnyelse på alla nätkort |
| D7 | ut | min server | internet | tcp/443 | tillåt | Paketuppdateringar (dnf) |
| D8 | in | valfri | min server | icmp echo-request, max 5/s | tillåt | Felsökning med ping |




