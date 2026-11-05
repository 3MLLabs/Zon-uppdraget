
# Loggkällekarta – elev-28

Workshop 1, del 1. Minst sex rader, exempelraden kopierad från din egen server.

| Källa | Var / hur den läses | Exempelrad (klistrad) | Vilken fråga den besvarar | Rotation | Hur långt bakåt | Tidsformat |
|---|---|---|---|---|---|---|
| journald | `journalctl --list-boots` | `0 06e1a50bb30c461685e586ebf51d1499 Sun 2026-10-04 15:45:06 UTC Tue 2026-11-03 12:48:21 UTC` | När startades servern? | Roterar själv efter storlek (journald.conf) | 4 oktober 2026 | UTC, `Nov 03 12:48:21` (utan år) |
| /var/log/messages | `sudo cat /var/log/messages` för alla, eller `sudo tail /var/log/messages` för de 10 sista | `Nov  3 13:12:14 elev-28 kernel: nft-drop-out IN= OUT=eth2 SRC=10.40.7.89 DST=10.40.7.66 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=45455 DF PROTO=TCP SPT=42196 DPT=80 WINDOW=64860 RES=0x00 SYN URGP=0` | Blev någonting droppat? | Varje vecka / 4 veckors backlogs | 4 veckor, sen deletas den första backloggen | UTC, utan år och tidszon |
| /var/log/secure | `sudo tail /var/log/secure` eller `sudo cat /var/log/secure` | `Nov  3 13:17:14 elev-28 sudo[86028]: student : TTY=pts/4 ; PWD=/home/student ; USER=root ; COMMAND=/bin/tail /var/log/messages` | Vilka commands har körts med root? | Varje vecka / 4 veckors backlogs | 4 veckor, sen deletas den första backloggen | UTC, utan år och tidszon |
| auditd | `sudo tail /var/log/audit/audit.log` | `type=USER_ACCT msg=audit(1793713013.576:7529): pid=86046 uid=1000 auid=1000 ses=147 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix acct="student" exe="/usr/bin/sudo" hostname=elev-28 addr=? terminal=/dev/pts/4 res=success'UID="student" AUID="student"` | Vilka commands har körts av vem? | Roterar själv efter storlek (auditd.conf) | Beror på storlek | Unix epoch (UTC) |
| last | `last` | `student  pts/0        172.20.1.2       Mon Oct  5 07:33 - 07:34  (00:00)` | Vem loggade in? | Varje månad (logrotate.d/wtmp) | Till 5 oktober | UTC, utan år |
| /var/log/dnf.rpm.log | `sudo grep -E 'Installed\|Upgrade\|Erase' /var/log/dnf.rpm.log* \| tail` | `2026-11-03T09:19:17+0000 SUBDEBUG Installed: rsyslog-gnutls-8.2510.0-2.el9_8.2.x86_64` | Vad har installerats? | Roterar själv efter storlek (dnf.conf) | Beror på storlek | ISO 8601, UTC (+0000) |

## Fem frågor och urval


# Loggkällekarta 


## Fem frågor och urval

Workshop 1, del 2. Frågor uppdragsgivaren måste kunna besvara i efterhand.

| # | Fråga (tidsspann, subjekt, vad som ska fastställas) | Källor som krävs | Går att besvara idag? |
|---|---|---|---|
| 1 | **Tidsspann:** 2026-11-02 00:00 – 2026-11-04 00:00 UTC. **Subjekt:** SSH-inloggningar mot elev-28. **Fastställ:** vilka konton loggade in eller försökte, från vilka IP-adresser, och lyckades de? | /var/log/secure | Ja, lokalt (ca 4 veckor bakåt) |
| 2 | **Tidsspann:** 2026-11-03 00:00 – 23:59 UTC. **Subjekt:** kontot `student`. **Fastställ:** vilka kommandon kördes som root via sudo, och vilken inloggningssession (auid/ses) låg bakom? | /var/log/secure, auditd | Ja, lokalt |
| 3 | **Tidsspann:** 2026-11-03 12:00 – 14:00 UTC. **Subjekt:** paketfiltret på elev-28 (`nft-drop-*`). **Fastställ:** vilka anslutningar droppades – källa, mål, port och riktning? | /var/log/messages | Ja, lokalt |
| 4 | **Tidsspann:** 2026-10-04 – 2026-11-04. **Subjekt:** programvara på elev-28. **Fastställ:** vad installerades, uppgraderades eller togs bort, när, och vem körde kommandot? | /var/log/dnf.rpm.log (vad/när), /var/log/secure (vem körde `sudo dnf`) | Delvis – dnf.rpm.log visar inte vem, det kräver secure |
| 5 | **Tidsspann:** 2026-10-04 – 2026-11-04. **Subjekt:** elev-28 och loggtjänsterna (rsyslog, auditd). **Fastställ:** har servern startats om, eller har någon loggtjänst stoppats, och när? | journald, auditd | Ja, lokalt – men en angripare med root kan radera spåren, därför behövs central insamling |

### Strukna källor och skäl

| Struken källa | Varför ingen fråga behöver den |
|---|---|
| last (wtmp) | Fråga 1 besvaras redan av /var/log/secure (konto, IP, tid, lyckat/misslyckat). wtmp tillför bara sessionslängd, som ingen fråga kräver, och tidsformatet saknar år, tidszon och sekunder. |

**Notering:** samma sshd-händelse finns i både journald och /var/log/secure – det är en händelse lagrad på två ställen, inte två händelser.