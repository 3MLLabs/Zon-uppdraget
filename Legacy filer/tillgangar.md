# Tillgångsförteckning

**Gjord av:** Martin (elev-40) · **Datum:** 2026-10-12 (tider i UTC)

| Namn | Roll | Adress | Tjänster | Belägg |
|---|---|---|---|---|
| elev-40 | Min labbserver | 172.20.1.140 | SSH 22, HTTP 80 | `ss -tulpn` 07:14Z, `systemctl status httpd` 07:17Z |
| jump-server | Enda vägen in till servrarna | 172.20.1.2 | SSH 22 | `ss -tnp` på elev-40 |
| Intern gateway | Router för labbnätet | 172.20.0.1 | Routing | `ip route` 07:14Z |
| Extern gateway | Väg mot internet, DHCP | 172.31.1.1 | DHCP 67, routing | `ip route` 07:14Z |
| DNS | Namnuppslag | 185.12.64.1, .2 | DNS 53 | `/etc/resolv.conf` 07:14Z |
| Gömd server | Webbserver (CTF U1.5) | 172.20.1.203 | HTTP 47213 (nginx) | `nmap` från elev-40 (U1.5) |

## Kommentarer

- **Port 80 på elev-40:** kursens testsida (Apache). Den nås från internet och skannas av okända adresser, men ingen i labbnätet använder den. Inget ändrat.
- **Gateways och DNS:** bara sett att de används, inte skannade.
