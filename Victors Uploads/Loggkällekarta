# Loggkällekarta – elev-40 (webb, 10.40.7.66)

## Del 1 – Källor

| Källa | Var / hur den läses | Exempelrad | Fråga | Rotation | Bakåt | Tid |
|---|---|---|---|---|---|---|
| sshd, sudo | `/var/log/secure` · `sudo tail /var/log/secure` | `Nov  3 12:51:10 elev-40 sudo[11566]: … session closed for user root` | Vem loggade in eller blev root? | varje vecka, 4 filer | ca 5 veckor | `Nov  3 12:51:10` – inget år, ingen tidszon |
| Brandväggen | journalen, `/var/log/messages` · `sudo journalctl -k -g ZON-` | `Nov 03 12:23:39 elev-40 kernel: ZON-IN-DROP … SRC=10.40.7.89 DST=10.40.7.66 DPT=443 SYN` | Vem försökte nå servern utan lov? | varje vecka, 4 filer | ca 5 veckor | samma |
| systemd | `/var/log/messages` · `sudo tail /var/log/messages` | `Nov  3 12:39:49 elev-40 systemd[11511]: Finished Cleanup …` | Stoppades en tjänst? | varje vecka, 4 filer | ca 5 veckor | samma |
| journald | `/run/log/journal` (minnet) · `journalctl` | Samma rader som secure och messages – räknas en gång | Vad hände sedan omstart? | ingen | sedan 28/10, raderas vid omstart | mikrosekunder, UTC |
| auditd | `/var/log/audit/audit.log` · `sudo ausearch -i` | `type=USER_START msg=audit(1793710645.126:2026): uid=1000 auid=1000 … exe="/usr/bin/sudo"` | Vem gjorde vad som root? | efter storlek | beror på mängd | epoktid + serienummer |
| Apache | `/var/log/httpd/access_log` · `sudo tail /var/log/httpd/access_log` | `91.92.40.240 - - [03/Nov/2026:12:40:01 +0000] "GET / HTTP/1.1" 200` | Vem besökte webben? | varje vecka, 4 filer | ca 5 veckor | med år och tidszon |
| cron | `/var/log/cron` · `sudo tail /var/log/cron` | `Nov  3 12:01:01 elev-40 CROND[11346]: (root) CMDEND …` | Körs ett jobb? | varje vecka, 4 filer | ca 5 veckor | inget år, ingen tidszon |
| dnf | `/var/log/dnf.log` · `sudo tail /var/log/dnf.log` | `2026-11-03T12:00:22+0000 DDEBUG Plugins were unloaded.` | Installerades ett paket? | varje vecka, 4 filer | ca 5 veckor | med år och tidszon |

Centralt sparas raderna i RFC 5424: med år, mikrosekunder och tidszon.

## Del 2 – Fem frågor

| # | Fråga | Källor | Går idag? |
|---|---|---|---|
| 1 | Vilka konton loggade in med SSH på elev-40 de senaste 30 dagarna, och varifrån? | sshd | ✅ |
| 2 | Vem körde kommandon som root på elev-40 natten till 3/11 kl 00–06, och vilka? | sudo, auditd (`root-cmd`) | ✅ Från 3/11 – auditd skickas centralt |
| 3 | Vilka adresser försökte nå elev-40 på stängda portar under vecka 45? | brandväggen | ✅ |
| 4 | Vem ändrade `/etc/nftables/zon.nft` den 3/11, och när? | auditd (`nft-andring`), sudo | ✅ Från 3/11 – auditregel och central insamling |
| 5 | Mellan 1 och 9 november: när slutade elev-40 skicka loggar, och vem stoppade rsyslog? | systemd, sudo | ⚠️ Delvis – tystnaden syns bara som saknade rader |

**Skickas centralt:** systemlogg, inloggningar, brandväggen och auditd. Över TLS 6514, med kö på disk.

auditd skickas med syslog-pluginet (`audispd-plugins`, `active = yes`). Auditregler i `/etc/audit/rules.d/50-milstolpe5.rules`:
```
-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=unset -k root-cmd
-a always,exit -F arch=b32 -S execve -F euid=0 -F auid>=1000 -F auid!=unset -k root-cmd
-w /etc/nftables/ -p wa -k nft-andring
```
Belägg centralt (`loggsök nft-andring` på jump):
```
mottaget 2026-11-03T13:44:30.479Z TLS | … elev-40 audisp-syslog[24146] type=SYSCALL … auid=1000 uid=0 … comm="touch" exe="/usr/bin/touch" key="nft-andring" AUID="student" UID="root"
```

## Strukna källor

| Källa | Varför |
|---|---|
| cron | Bara systemets egna jobb. Brus. |
| mail, spooler | Tomma. |
| dnf | Ändringar görs med sudo och syns där. |
| btmp, wtmp | Samma inloggningar som i secure. Roteras varje månad, 1 fil. |
| Apache | Ingen fråga gäller webbesök. |
| chrony | Tiden kontrolleras med `chronyc tracking`. |

## Rotation – belägg
Gemensamt i `/etc/logrotate.conf`:
```
weekly
rotate 4
dateext
```
Egna regler i `/etc/logrotate.d/` (`grep -E 'daily|weekly|monthly|rotate|maxsize' /etc/logrotate.d/*`):

| Fil | Regel | Betydelse |
|---|---|---|
| rsyslog (secure, messages, cron) | bara `postrotate` | gemensamt: varje vecka, 4 filer |
| httpd | bara `postrotate` | gemensamt: varje vecka, 4 filer |
| dnf | `weekly`, `rotate 4` | varje vecka, 4 filer |
| btmp, wtmp | `monthly`, `rotate 1` | varje månad, 1 fil |

auditd roteras inte av logrotate, utan efter storlek i `/etc/audit/auditd.conf`. journald roteras inte, eftersom den ligger i minnet.

## Varför loggarna måste lämna servern
1. Journalen ligger i minnet och försvinner vid omstart:
   ```
   $ journalctl -b -1 --no-pager
   Specifying boot ID or boot offset has no effect, no persistent journal was found.
   ```
2. Root kan ändra eller radera filerna.
3. Filerna raderas efter ca 5 veckor. Kravet är minst 6 månader.
