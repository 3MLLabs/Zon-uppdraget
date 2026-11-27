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
| F1 | in | Klient 10.40.7.2 | Webb 10.40.7.66 | tcp/443 | nekas (borttagen 27/11) | Ingen tjänst lyssnar på 443 (`ss -tlnp`). En öppen regel utan tjänst gör ingenting. Läggs tillbaka om TLS sätts upp i httpd. |
| F2 | in | Klient 10.40.7.2 | Webb 10.40.7.66 | tcp/80 | tillåt | Användarna når webbtjänsten (http) |
| F3 | in | Webb 10.40.7.66 | App 10.40.7.89 | tcp/8080 | tillåt | Webbservern anropar applikationen; bara webbzonen behöver nå appen |
| F4 | in | App 10.40.7.89 | Databas 10.40.7.73 | tcp/5432 | tillåt | Bara applikationen ska läsa och skriva data; databasen är den känsligaste tillgången |

## D-regler – driftflöden (samma på alla servrar)

| Id | Riktning | Källa | Mål | Proto/port | Beslut | Motivering |
|---|---|---|---|---|---|---|
| D1 | in | jump 172.20.1.2 | min server | tcp/22 | tillåt | All inloggning går via jump |
| D2 | in | ctf 172.20.1.10 | min server | tcp/22 | tillåt | Kursens kontrolltjänst för CTF-labbarna |
| D3 | ut | min server | 185.12.64.1, 185.12.64.2 | tcp+udp/53 | tillåt | DNS-uppslag |
| D4 | ut | min server | ntp3.hetzner.de 213.239.239.166 | udp/123 | tillåt | Tidssynk (NTP), krävs för spårbara loggar. Bara den server som chrony använder (`chronyc -n sources`). |
| D5 | ut | min server | log 172.20.1.58 | tcp/6514 | tillåt | Loggar till den gemensamma loggservern |
| D6 | ut | min server (udp/68) | DHCP (udp/67) | udp | tillåt | DHCP-förnyelse på alla nätkort |
| D7 | ut | min server | internet, inte 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 | tcp/443 | tillåt | Paketuppdateringar (dnf). dnf väljer spegel via mirrorlist, så det finns ingen fast adress. Interna nät och teamnätet är stängda. |
| D8 | in | valfri | min server | icmp echo-request, max 5/s | tillåt | Felsökning med ping |
| D9 | in | ctf 172.20.1.10 | Webb 10.40.7.66 | tcp/80 | tillåt | Kursens kontroll hämtar webbsidan /zon/ (U7.2), bara på webbservern |
| D10 | in | ctf 172.20.1.10 | min server | tcp/7540 | tillåt | Kursens kontroll når zonvakt (U7.3). Porten är 7500 + elevnummer. |

## Ändringslogg

| Datum | Id | Ändring | Kontroll |
|---|---|---|---|
| 27/11 | D4 | Från "internet" till bara 213.239.239.166 | `chronyc burst 2/2` → svar kommer igenom |
| 27/11 | D7 | Från "internet" till internet utom interna nät | `dnf makecache --refresh` fungerar. Test mot 172.20.1.58:443 → tyst. |
| 27/11 | F1 | Borttagen på webbservern | `ss -tlnp` → inget på 443. `nft list chain inet zon in` → ingen dport 443. |
