# Spårbarhetslista – elev-40 (webb, 10.40.7.66)

Regelns identifierare = kommentaren i nftables (`comment "…"`) och beskrivningen i molnbrandväggen. Status: planerad · implementerad · verifierad.

| Rad-id | Riktning | Källa | Mål | Proto/port | Lager | Regelns identifierare | Loggar? | Status |
|---|---|---|---|---|---|---|---|---|
| D1 | in | jump 172.20.1.2 | elev-40 | tcp/22 | värd | "D1 SSH från jump" | nej | verifierad – ny SSH-session, även efter omstart |
| D2 | in | ctf 172.20.1.10 | elev-40 | tcp/22 | värd | "D2 kontroll från ctf" | nej | verifierad – kontrollera U4.1, U5.1, U5.3 |
| F1 | in | internet (eth0) | elev-40 | tcp/443 | moln + värd | "F1 webb https" (moln) · "F1 webb https internet" (värd) | nej | verifierad – jump → 2.28.97.87:443 oppen |
| F1 | in | klient 10.40.7.0/26 | elev-40 | tcp/443 | värd | "F1 webb https klient" | nej | implementerad – klienten ej kopplad 3/11 |
| F2 | in | internet (eth0) | elev-40 | tcp/80 | moln + värd | "F2 webb http" (moln) · "F2 webb http internet" (värd) | nej | verifierad – `curl -I http://2.28.97.87` gav 200 OK |
| F2 | in | klient 10.40.7.0/26 | elev-40 | tcp/80 | värd | "F2 webb http klient" | nej | implementerad – klienten ej kopplad 3/11 |
| D8 | in | alla | elev-40 | icmp echo, max 5/s | värd | "D8 ping" | nej | verifierad – ping från teamet |
| D3 | ut | elev-40 | 185.12.64.1, .2 | udp+tcp/53 | värd (molnet släpper alltid) | "D3 DNS" | nej | verifierad – dnf hittar paketförråden |
| D4 | ut | elev-40 | internet | udp/123 | moln + värd | "D4 NTP" (båda) | nej | verifierad – chronyc tracking: ntp2.hetzner.de, Leap status Normal |
| D5 | ut | elev-40 | log 172.20.1.58 | tcp/6514 (TLS) | värd | "D5 logg till log TLS" | nej | verifierad – ss ESTAB :6514, U5.1 och U5.3 (loggsök visar TLS) |
| D6 | ut | elev-40 | DHCP | udp 68→67 | värd (molnet släpper alltid) | "D6 DHCP-förnyelse" | nej | implementerad |
| D7 | ut | elev-40 | internet | tcp/443 | moln + värd | "D7 dnf" (båda) | nej | verifierad – dnf install rsyslog-gnutls och audispd-plugins |
| F3 | ut | elev-40 | app 10.40.7.89 | tcp/8080 | värd | "F3 webb till app" | nej | verifierad – matris.sh: kan prata / avvisad (RST från app) |
| D8 | ut | elev-40 | teamnätet 10.40.7.0/24 | icmp echo | värd | "D8 ping ut till teamet" | nej | verifierad – ping till .73 och .89 svarar |
| – | in | allt annat | elev-40 | – | värd | policy drop + "ZON-IN-DROP " | **ja** | verifierad – app .89 → 443 och databas .73 → 8080/22 nekade i loggen |
| – | ut | elev-40 | allt annat | – | värd + moln | policy drop + "ZON-UT-DROP " | **ja** | verifierad – matris.sh: webb → databas och app (ej 8080) tyst |

Beständigt: include i /etc/sysconfig/nftables.conf, `systemctl enable nftables` – omstartstest 2026-10-28 

Ändringar:
- 2/11: F1/F2 begränsade till internet (eth0) och klient efter avvikelse (databasen nådde webben). D5 till tcp/6514 (TLS). D8 ping ut tillagd. F5 borttagen (ingen admin-zon).
- 3/11: F3 till exakt adress 10.40.7.89.
