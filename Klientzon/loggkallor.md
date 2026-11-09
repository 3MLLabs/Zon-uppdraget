# Loggkällekarta – elev-42 (webb)

Server: elev-42
IP-adresser:
- eth0: 2.28.111.243
- eth1: 172.20.1.142
- eth2: 10.40.7.2

## Del 1 – Källor

| Källa | Var/hur den läses | Exempelrad (klistrad) | Vilken fråga den besvarar | Rotation | Hur långt bakåt | Tidsformat |
|---|---|---|---|---|---|---|
| sshd, sudo | `/var/log/secure` · `sudo tail /var/log/secure` | `Nov  9 07:43:32 elev-42 sshd-session[5623]: Accepted publickey for student from 172.20.1.2 port 35928 ssh2` | Vem loggade in eller blev root? | Varje vecka, 4 filer enligt grundregeln | Cirka 5 veckor enligt grundregeln | Månad, dag och klockslag, inget år eller tidszon |
| Brandväggen | journald/kernel · `sudo journalctl -k -g nft-drop-in` | `Nov 09 02:07:49 elev-42 kernel: nft-drop-in IN=eth0 OUT= MAC=92:00:0a:0d:66:71:d2:74:7f:6e:37:e3:08:00 SRC=188.166.79.100 DST=2.28.111.243 LEN=60 TOS=0x00 PREC=0x00 TTL=53 ID=45681 DF PROTO=TCP SPT=48048 DPT=443 WINDOW=64240 RES=0x00 SYN URGP=0` | Vilka IP-adresser försökte nå servern på blockerade portar? | Ingen logrotate, journalen ligger i minnet | Sedan senaste uppstarten | År, datum och klockslag, UTC |
| systemd och systemlogg | `/var/log/messages` · `sudo tail /var/log/messages` | `Nov  9 07:44:26 elev-42 audisp-syslog[5203]: type=USER_START msg=audit(1794210266.562:1520): pid=5679 uid=1000 auid=1000` | Startades eller stoppades en tjänst? | Varje vecka, 4 filer enligt grundregeln | Cirka 5 veckor enligt grundregeln | Månad, dag och klockslag, inget år eller tidszon |
| journald | `/run/log/journal` · `journalctl` | `IDX 0 e728544f8907474ab708ba2f0fc956f1 Thu 2026-11-05 08:43:32 UTC` | Vad hände sedan senaste omstarten? | Ingen rotation med logrotate | Sedan 5/11 2026, raderas vid omstart | År, mikrosekunder och UTC |
| auditd | `/var/log/audit/audit.log` · `sudo ausearch -i` | `type=SYSCALL msg=audit(1794210292.888:1539): arch=c000003e syscall=59 success=yes exit=0 ... comm="tail" exe="/usr/bin/tail" key="root_commands" ARCH=x86_64 SYSCALL=execve AUID="student" UID="root"` | Vem körde kommandon som root? | Efter storlek, max 8 MB, 5 filer | Beror på loggmängd | Epoktid med mikrosekunder och serienummer |
| Apache | `/var/log/httpd/access_log` · `sudo tail /var/log/httpd/access_log` | Ingen rad i aktuell access_log. Äldre exempel finns i `access_log-20261101` | Vem besökte webbservern? | Veckovis rotation verkar förekomma | Flera veckor, exakt historik ej verifierad | Apache-format med år och tidszon |
| cron | `/var/log/cron` · `sudo tail /var/log/cron` | Exempelrad ej hämtad ännu | Körs ett schemalagt jobb? | Varje vecka, 4 filer enligt grundregeln | Cirka 5 veckor enligt grundregeln | Månad, dag och klockslag, inget år eller tidszon |
| dnf | `/var/log/dnf.log` · `sudo tail /var/log/dnf.log` | Exempelrad ej hämtad ännu | Installerades eller uppdaterades ett paket? | Veckovis enligt grundregeln, individuell regel ej verifierad | Ej fastställd | ISO 8601 med år och tidszon |

Centralt skickas loggar via rsyslog till 172.20.1.58.

TLS-konfiguration finns i `/etc/rsyslog.d/50-tls.conf`:
- Port: 6514
- TLS-drivrutin: gtls
- Autentisering: x509/name
- Tillåten mottagaridentitet: log.sec.chas-lab.dev
- CA-certifikat: /etc/pki/rsyslog/ca.pem

Aktiv TCP-anslutning:
172.20.1.142:35750 -> 172.20.1.58:6514

Diskkö:
- queue.type="LinkedList"
- queue.filename="fwd"
- queue.saveOnShutdown="on"

Brandväggsloggar skickas separat via TCP port 514 till 172.20.1.58.

Rsyslog är aktivt och körs sedan 5/11 2026.

Auditd skickar auditmeddelanden via audisp-syslog till systemloggen.

## Del 2 – Fem frågor

| # | Fråga (tidsspann, subjekt, vad som ska fastställas) | Källor som krävs | Går att besvara idag? |
|---|---|---|---|
| 1 | Vilka konton loggade in med SSH på elev-42 under de senaste 30 dagarna, och från vilka IP-adresser? | sshd (`secure`) | Ja, delvis. SSH-inloggningar registreras, men hela perioden behöver undersökas. |
| 2 | Vem körde kommandon som root på elev-42 natten till 3/11 kl. 00–06, och vilka kommandon kördes? | sudo, auditd (`root_commands`) | Ja, från befintliga auditloggar. |
| 3 | Vilka IP-adresser försökte nå elev-42 på blockerade portar under vecka 45? | Brandväggen (`journalctl -k`) | Delvis. Brandväggsloggar finns men journalens historik måste kontrolleras. |
| 4 | Vem ändrade `/etc/nftables/` den 3/11, och när? | auditd, sudo | Nej. Någon särskild auditregel för nftables-ändringar har inte hittats. |
| 5 | Mellan 1 och 9 november: när slutade elev-42 skicka loggar, och vem stoppade rsyslog? | systemd, sudo, central logginsamling | Delvis. Rsyslog är aktivt nu, men historiska avbrott måste undersökas. |

## Centrala loggar

Rsyslog skickar loggar till den centrala servern 172.20.1.58.

TLS:
- Port 6514.
- TLS med gtls.
- Autentisering med x509/name.
- Tillåten serveridentitet: log.sec.chas-lab.dev.

Diskkö:
- LinkedList.
- queue.filename="fwd".
- queue.saveOnShutdown="on".

En separat överföring av brandväggsloggar finns på TCP port 514.

Aktiva anslutningar har verifierats med `ss -tnp`.

Auditd skickar auditmeddelanden via audisp-syslog.

Aktiva auditregler:

-a always,exit -F arch=b64 -S execve -F euid=0 -F key=root_commands
-a always,exit -F arch=b32 -S execve -F euid=0 -F key=root_commands

Ingen regel för nftables-ändringar har hittats.

## Del 3 – Strukna källor

| Struken källa | Varför ingen fråga behöver den |
|---|---|
| mail, maillog | Maillog är tom och ingen fråga gäller e-post. |
| spooler | Spooler är tom och ingen fråga gäller utskrifter. |
| dnf | Kan strykas eftersom ingen av de fem frågorna gäller paketinstallationer. |
| btmp, wtmp | Innehåller inloggningshistorik, men SSH-detaljer finns i secure. |
| Apache | Kan strykas om ingen fråga gäller webbplatsbesök. |
| chrony | Tiden kan kontrolleras med `chronyc tracking`. |

## Del 4 – Rotation och belägg

Gemensamt i `/etc/logrotate.conf`:

weekly
rotate 4
create
dateext

Det betyder:
- Loggar roteras varje vecka.
- Fyra gamla filer sparas.
- Nya tomma loggfiler skapas efter rotation.
- Datum används som suffix.

Faktiska filer som finns:

| Fil | Belägg |
|---|---|
| secure | secure-20261018, secure-20261025, secure-20261101, secure-20261108 |
| messages | messages-20261018, messages-20261025, messages-20261101, messages-20261108 |
| cron | cron-20261018, cron-20261025, cron-20261101, cron-20261108 |
| Apache access | access_log-20261011, access_log-20261018, access_log-20261025, access_log-20261101 |
| Apache error | error_log-20261018, error_log-20261025, error_log-20261101, error_log-20261108 |

Individuella regler i `/etc/logrotate.d/` behöver kontrolleras.

Auditd roteras inte med logrotate utan efter storlek i `/etc/audit/auditd.conf`:

max_log_file = 8
num_logs = 5
max_log_file_action = ROTATE
space_left_action = SYSLOG

Det betyder att auditd roterar vid 8 MB och behåller fem loggfiler enligt konfigurationen.

Journald roteras inte med logrotate eftersom den ligger i minnet under `/run/log/journal`.

## Del 5 – Varför loggarna måste lämna servern

1. Journald ligger i minnet och försvinner vid omstart.
2. Root kan ändra eller radera lokala loggfiler.
3. Loggrotationen sparar bara ett begränsat antal gamla filer.
4. Kravet på minst sex månaders lagring kan inte garanteras med enbart lokal lagring.
5. Central logginsamling gör att loggar kan finnas kvar även om servern startas om eller komprometteras.

