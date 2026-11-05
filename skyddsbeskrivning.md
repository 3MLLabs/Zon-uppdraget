# Skyddsbeskrivning – elev-40 (webb, 10.40.7.66)

Team 7 · Milstolpe 5 · 5/11

Kedjan: program → journald → rsyslog → log 172.20.1.58:6514 (TLS).

## 1. Vem kan ändra loggen lokalt?
Den som är root.

| Vem | Belägg |
|---|---|
| root | Loggfilerna: `-rw------- root root` |
| student | `groups student`: `wheel` · sudoers: `%wheel ALL=(ALL) ALL` |
| Läraren | Nyckel för root: `peter-aspenberg@mac` |
| ctf | Nyckel för root, bara från 172.20.1.10: `ctf-elevkoll` |

Journalen ligger i minnet (`/run/log/journal`) och försvinner vid omstart.

## 2. Vem kan ändra loggen centralt?
Ingen elev. Bara kursens administratörer (ej verifierat).

| Belägg | Betydelse |
|---|---|
| `ssh log`: `Permission denied (publickey…)` | Inget konto på log |
| `ZON-UT-DROP … DST=172.20.1.58 DPT=22` | elev-40 når bara 6514 på log |
| `loggsök` | Elever kan bara läsa |

Root på elev-40 kan skicka falska rader, men inte radera det som redan finns på log. TLS skyddar bara transporten.

## 3. Lagringstid
Krav: minst 6 månader (F1).

| Var | Rotation | Bakåt | Belägg |
|---|---|---|---|
| secure, messages | varje vecka, 4 filer | ca 5 veckor | `logrotate.conf`: `weekly`, `rotate 4` |
| audit.log | 5 filer × 8 MB | ca 4 månader | `auditd.conf`: `max_log_file = 8`, `num_logs = 5` |
| journalen | – | till omstart | i minnet |
| log (centralt) | kursen | ej verifierat | fråga ställd till Peter |

Lokalt räcker inte. Den centrala lagringen måste klara kravet.

## 4. När log inte går att nå
Konfiguration: `queue.filename="fwd_tls"`, `queue.saveOnShutdown="on"`, `action.resumeRetryCount="-1"`.

| Fråga | Svar |
|---|---|
| Sparas kön på disk? | Ja. U5.2: `fwd_tls.00000001` efter omstart |
| Ger rsyslog upp? | Nej, försöker igen utan slut |
| Gräns? | Ingen satt. Gränsen blir ledig disk: 35 GB (`df -h`) |
| När disken är full? | Nya loggar kastas |
| Kommer loggen fram? | Ja, med rätt tid. U5.2: skapad 09:33:44, mottagen 09:36:21 |

Risker: kön kan fylla systemdisken. Data i TCP-bufferten kan försvinna (U5.2: `Send-Q 20775`).
Förbättring: sätt `queue.maxDiskSpace`.

## Scenario: angripare med root
**Kan förstöra lokalt:** radera loggfiler, starta om (journalen försvinner), stoppa rsyslog eller auditd, blockera 6514, radera kön, skicka falska rader.

**Kedjan fångar ändå:**
- Inloggningen – når log inom 0,4 s.
- Root-kommandon med auid=student (U5.3).
- Ändringar i `/etc/nftables/` (`nft-andring`).
- Allt som redan finns på log.
- Tystnaden – när elev-40 slutar skicka syns det.

**Luckor:** intrång via en tjänst (`auid=unset`) loggas inte av `root-cmd`. Falska rader syns inte som falska.

**Slutsats:** angriparen kan förstöra allt lokalt, men inte det som redan finns på log.
