# Verifieringsanteckning – elev-40 (webb, 10.40.7.66)

Team 7 · Vecka 5 · Workshop 2 · Sökt med `loggsök` på jump

| Identifierare | Tid (UTC) | Värdnamn | Källa | Söksträng | Hittad centralt? | Avvikelse? |
|---|---|---|---|---|---|---|
| sparee68fea3 (U5.1) | 2/11 07:41:30 | elev-40 | user.notice (`logger -t sparbarhet`) | `loggsök sparee68fea3` | TLS | Nej. Skickad 07:41:30.006, mottagen 07:41:30.131. |
| Inloggning student | 3/11 12:23:12 | elev-40 | authpriv (sshd) | `loggsök "Accepted"` | TLS | Nej. Skickad 12:23:12.676, mottagen 12:23:12.944. |
| Nekat paket från databasen | 3/11 12:06:49 | elev-40 | kern (nftables `ZON-IN-DROP`) | `loggsök ZON-IN-DROP` | TLS | Nej. `SRC=10.40.7.73 DST=10.40.7.66 DPT=443 SYN` – visar också att F1 nekar databasen. |
| spar706320e4 (U5.3) | 3/11 13:40:23 | elev-40 | auditd (`root-cmd`, audisp-syslog) | `loggsök spar706320e4` | TLS | Nej. EXECVE `/usr/bin/touch /tmp/spar706320e4`, auid=student. |
| nft-andring | 3/11 13:44:30 | elev-40 | auditd (`nft-andring`, audisp-syslog) | `loggsök nft-andring` | TLS | Nej. `comm="touch" key="nft-andring" AUID="student" UID="root"`. |

## Jämförelse lokalt och centralt
| Fält | Lokalt | Centralt |
|---|---|---|
| Tidsstämpel | RFC 3164: `Nov  3 12:23:12` – inget år, ingen tidszon | RFC 5424: `2026-11-03T12:23:12.676897+00:00` – år, mikrosekunder, tidszon |
| Värdnamn | `elev-40` | `elev-40` + källadress `172.20.1.140` |
| Källa | `sshd-session[11357]` | samma |
| Meddelande | `Accepted password for student from 172.20.1.2 …` | samma |
| Kanal | – | `TLS` (port 6514) |
| Fördröjning | – | 0,1–0,4 s mellan sändning och mottagning |

## Iakttagelse
- `Accepted publickey for root from 172.20.1.10` (13:41:56): ctf-servern loggar in som root med nyckel. Det är D2 (kursens kontrolltjänst). Bra att veta i skyddsbeskrivningen: ctf har root på servern.

## Slutsats
Alla tre källor i milstolpen kommer fram centralt över TLS med rätt värdnamn och tid: **system** (user/logger), **autentisering** (sshd) och **brandvägg** (kern). auditd kommer också fram.

## Efter omstart (9/11)
| Steg | Belägg |
|---|---|
| Omstart | `sudo reboot` 08:26:55 UTC |
| Brandväggen laddad | `nft list ruleset`: `table inet zon`, `policy drop` |
| Första försöken | `SYN-SENT` från 2.28.97.87 (eth0) – rsyslog startade innan rutten till labbnätet fanns |
| Vägen | `ip route get 172.20.1.58`: `via 172.20.0.1 dev eth1 src 172.20.1.140` |
| Nytt försök | `ESTAB` 172.20.1.140 → 172.20.1.58:6514, Send-Q 0 |
| Centralt | `loggsök "efter omstart"`: skapad 08:29:11, mottagen 08:29:22, TLS, elev-40 |

Insamlingen fungerar efter omstart. De första sekunderna gick via fel väg, men kön och `resumeRetryCount="-1"` gjorde att inget försvann.
