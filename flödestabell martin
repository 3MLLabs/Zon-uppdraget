# Flödestabell – team 7

Varje rad är ett flöde. Id:t står som `comment` i nftables-regeln.
Riktning är sedd från servern som regeln ligger på.
Ett flöde mellan två servrar behöver två regler: `ut` på avsändaren och `in` på mottagaren.
Allt som inte står i tabellen nekas (policy drop i båda riktningarna).

## Servrar

| Zon | Server | Adress |
|---|---|---|
| Klient | elev-28 | 10.40.7.10 |
| Webb | elev-40 | 10.40.7.66 |
| App | elev-42 | 10.40.7.74 |
| Databas | elev-19 | 10.40.7.90 |

## Tjänsteflöden (F)

| Id | Källa | Mål | Protokoll/port | Beslut | Regel på källa | Regel på mål | Lager | Motivering |
|---|---|---|---|---|---|---|---|---|
| F1 | Klient 10.40.7.10 och internet | Webb 10.40.7.66 | tcp 443 | Tillåt | Klient: `ut` | Webb: `in` | Värd + molnbrandvägg (internet) | Användare når webben med https |
| F2 | Klient 10.40.7.10 och internet | Webb 10.40.7.66 | tcp 80 | Tillåt | Klient: `ut` | Webb: `in` | Värd + molnbrandvägg (internet) | Omdirigering från http till https |
| F3 | Webb 10.40.7.66 | App 10.40.7.74 | tcp 8080 | Tillåt | Webb: `ut` | App: `in` | Värd | Webben hämtar data från appen |
| F4 | App 10.40.7.74 | Databas 10.40.7.90 | tcp 5432 | Tillåt | App: `ut` | Databas: `in` | Värd | Appen läser och skriver i databasen |

## Nekade flöden (N)

| Id | Källa | Mål | Protokoll/port | Beslut | Lager | Motivering |
|---|---|---|---|---|---|---|
| N1 | Webb 10.40.7.66 | Databas 10.40.7.90 | tcp 5432 | Neka | Värd | Webben får inte hoppa över appen |
| N2 | Klient 10.40.7.10 | App 10.40.7.74 | tcp 8080 | Neka | Värd | Klienten får bara nå webben |
| N3 | Klient 10.40.7.10 | Databas 10.40.7.90 | tcp 5432 | Neka | Värd | Klienten får aldrig nå databasen |
| N4 | Internet | Alla servrar | tcp 22 | Neka | Molnbrandvägg + värd | SSH går bara via jump |

## Driftflöden (D) – samma på alla servrar

| Id | Riktning | Källa | Mål | Protokoll/port | Beslut | Lager | Motivering |
|---|---|---|---|---|---|---|---|
| D1 | in | jump 172.20.1.2 | Servern | tcp 22 | Tillåt | Värd | Administration via SSH |
| D2 | in | ctf 172.20.1.10 | Servern | tcp 22 | Tillåt | Värd | Kontroll av CTF-labbar |
| D3 | ut | Servern | 185.12.64.1, 185.12.64.2 | tcp + udp 53 | Tillåt | Värd | DNS-uppslag |
| D4 | ut | Servern | NTP-servrar | udp 123 | Tillåt | Värd + molnbrandvägg | Rätt tid i loggarna |
| D5 | ut | Servern | log 172.20.1.58 | tcp 514 | Tillåt | Värd | Brandväggsloggar till loggservern (TLS 6514 från vecka 5) |
| D6 | ut | Servern | DHCP-server | udp 68 → 67 | Tillåt | Värd | Förnyelse av adress |
| D7 | ut | Servern | Paketförråd | tcp 443 | Tillåt | Värd + molnbrandvägg | Uppdateringar med dnf |
| D8 | in + ut | Teamnätet 10.40.7.0/24 | Teamnätet 10.40.7.0/24 | icmp echo-request | Tillåt (in: max 5/s) | Värd | Felsökning med ping |

## Regler per server

| Server | Kedja `in` | Kedja `ut` |
|---|---|---|
| Klient elev-28 | D1, D2, D8 | D3–D8, F1, F2 |
| Webb elev-40 | D1, D2, D8, F1, F2 | D3–D8, F3 |
| App elev-42 | D1, D2, D8, F3 | D3–D8, F4 |
| Databas elev-19 | D1, D2, D8, F4 | D3–D8 |

## Loggning

Sista regeln i båda kedjorna loggar det som nekas:

- `limit rate 10/minute log prefix "ZON-IN-DROP " level info`
- `limit rate 10/minute log prefix "ZON-UT-DROP " level info`
