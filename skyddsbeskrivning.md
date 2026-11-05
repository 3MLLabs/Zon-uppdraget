# Skyddsbeskrivning: loggkedja

**Team / zon:** Team 7 – Appzon
**Server:** 10.40.7.89
**Central loggmottagare:** log.sec.chas-lab.dev
**Datum:** 2026-11-05

## Översikt av loggkedjan

```

Loggarna på elev-28 (172.20.1.128) samlas in lokalt och skickas vidare till kursens gemensamma loggserver 172.20.1.58 (log.sec.chas-lab.dev) över TLS på port 6514.
```

---

## 1. Lokalt

### 1.1 Vilka loggar samlas in


**Påstående:**

Tre tjänster samlar in loggar.

Journald: tar emot loggar från alla systemd-tjänster och kärnan

rsyslog: läser från journald och skriver till textfiler i /var/log/ och skickar vidare till loggservern

auditd: loggar säkerhetshändelser och skickar dem även till syslog via "audisp-syslog"

**Belägg:**

```bash ls -l /var/log/secure /var/log/messages /var/log/audit/
-rw-------. 1 root root 1814924 Nov  5 15:01 /var/log/messages
-rw-------. 1 root root   92338 Nov  5 14:43 /var/log/secure

```
```● rsyslog.service - System Logging Service
     Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-11-03 14:36:22 UTC; 2 days ago

```
```


● auditd.service - Security Auditing Service
     Loaded: loaded (/usr/lib/systemd/system/auditd.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-11-04 13:13:05 UTC; 1 day 1h ago
       Docs: man:auditd(8)
             https://github.com/linux-audit/audit-documentation
    Process: 99699 ExecStart=/sbin/auditd (code=exited, status=0/SUCCESS)
    Process: 99706 ExecStartPost=/sbin/augenrules --load (code=exited, status=0/SUCCESS)
   Main PID: 99700 (auditd)
      Tasks: 5 (limit: 22511)
     Memory: 3.5M (peak: 4.1M)
        CPU: 1.320s
     CGroup: /system.slice/auditd.service
             ├─99700 /sbin/auditd
             ├─99702 /sbin/audisp-syslog LOG_INFO


```

### 1.2 Behörigheter på loggfiler

**Påstående:**

De säkerhetsrelevanta loggfilerna (messages, secure, cron) ägs av root och har rättigheterna 600
Audit har 700 så vanliga användare inte kan läsa den
Roterande har 600 

**Belägg:**
```bash
ls -l /var/log/
total 5720
drwxr-xr-x. 2 root   root      4096 Aug 25 13:22 anaconda
drwx------. 2 root   root      4096 Aug 25 13:22 audit
-rw-rw----. 1 root   utmp      1152 Nov  3 10:52 btmp
-rw-rw----. 1 root   utmp      9216 Oct 29 19:33 btmp-20261101
drwxr-x---. 2 chrony chrony    4096 Dec 27  2025 chrony
-rw-r-----. 1 root   root    107703 Oct  4 15:45 cloud-init.log
-rw-r-----. 1 root   adm       4690 Oct  4 15:45 cloud-init-output.log
-rw-------. 1 root   root     40304 Nov  5 15:01 cron
-rw-------. 1 root   root     54791 Oct 10 23:01 cron-20261011
-rw-------. 1 root   root     59237 Oct 17 23:01 cron-20261018
-rw-------. 1 root   root     59405 Oct 24 23:01 cron-20261025
-rw-------. 1 root   root     59311 Oct 31 23:01 cron-20261101
-rw-r--r--. 1 root   root    404768 Nov  5 15:15 dnf.librepo.log
-rw-r--r--. 1 root   root    886892 Nov  5 15:15 dnf.log
-rw-r--r--. 1 root   root     46003 Nov  5 15:15 dnf.rpm.log
-rw-r--r--. 1 root   root      2220 Nov  5 15:15 hawkey.log
-rw-r--r--. 1 root   root      3300 Oct 10 21:55 hawkey.log-20261011
-rw-r--r--. 1 root   root      2580 Oct 17 21:14 hawkey.log-20261018
-rw-r--r--. 1 root   root      2760 Oct 24 22:59 hawkey.log-20261025
-rw-r--r--. 1 root   root      2820 Oct 31 20:23 hawkey.log-20261101
drwx------. 2 root   root      4096 Nov  1 00:00 httpd
-rw-rw-r--. 1 root   utmp    292292 Nov  5 12:57 lastlog
-rw-------. 1 root   root         0 Nov  1 00:00 maillog
-rw-------. 1 root   root         0 Aug 25 13:18 maillog-20261011
-rw-------. 1 root   root         0 Oct 11 00:00 maillog-20261018
-rw-------. 1 root   root         0 Oct 18 00:00 maillog-20261025
-rw-------. 1 root   root         0 Oct 25 00:00 maillog-20261101
-rw-------. 1 root   root   1818237 Nov  5 15:15 messages
-rw-------. 1 root   root    393185 Oct 10 23:13 messages-20261011
-rw-------. 1 root   root     84620 Oct 18 00:00 messages-20261018
-rw-------. 1 root   root     73393 Oct 24 22:59 messages-20261025
-rw-------. 1 root   root   1308867 Nov  1 00:00 messages-20261101
drwx------. 2 root   root      4096 Aug 25 13:17 private
lrwxrwxrwx. 1 root   root        39 Aug 25 13:17 README -> ../../usr/share/doc/systemd/README.logs
-rw-------. 1 root   root     92338 Nov  5 14:43 secure
-rw-------. 1 root   root     52151 Oct  9 09:29 secure-20261011
-rw-------. 1 root   root      5994 Oct 14 16:37 secure-20261018
-rw-------. 1 root   root      5775 Oct 22 12:06 secure-20261025
-rw-------. 1 root   root     55587 Oct 29 20:04 secure-20261101
-rw-------. 1 root   root         0 Nov  1 00:00 spooler
-rw-------. 1 root   root         0 Aug 25 13:18 spooler-20261011
-rw-------. 1 root   root         0 Oct 11 00:00 spooler-20261018
-rw-------. 1 root   root         0 Oct 18 00:00 spooler-20261025
-rw-------. 1 root   root         0 Oct 25 00:00 spooler-20261101
drwxr-x---. 2 sssd   sssd      4096 Oct 11 00:00 sssd
-rw-rw-r--. 1 root   utmp     64512 Nov  5 13:18 wtmp

```

### 1.3 Persistent journal

**Påstående:**
Journalen sparas bara i minnet och försvinner vid omstart, eftersom /var/log/journal inte finns
**Belägg:**
```bash
ls -ld /var/log/journal
journalctl --list-boots | head -n 3
ls: cannot access '/var/log/journal': No such file or directory
IDX BOOT ID                          FIRST ENTRY                 LAST ENTRY
  0 06e1a50bb30c461685e586ebf51d1499 Sun 2026-10-04 15:45:06 UTC Thu 2026-11-05 15:26:30 UTC

```



### 1.4 Manipuleringsskydd

**Påstående:**

En vanlig användare kan inte skriva till loggfilerna (Permission denied) och kan inte radera dem, eftersom katalogen /var/log ägs av root och bara root har skrivrätt i den. Den som blir root via sudo loggas i /var/log/secure med användarnamn, terminal, tidpunkt och exakt kommando, och raden skickas vidare till loggservern. Root kan däremot ändra och radera de lokala loggarna, så lokalt skydd räcker inte ensamt.

**Belägg:**
```bash
[student@elev-28 ~]$ sudo whoami
root
[student@elev-28 ~]$ sudo tail -n 3 /var/log/secure
Nov  5 17:41:14 elev-28 sudo[101072]: student : TTY=pts/2 ; PWD=/home/student ; USER=root ; COMMAND=/bin/whoami
```
```bash
[student@elev-28 ~]$ ls -ld /var/log
drwxr-xr-x. 8 root root 4096 Nov  1 00:00 /var/log

```

---

## 2. Centralt

### 2.1 Vidarebefordran

**Påstående:**

rsyslog skickar loggarna till loggservern 172.20.1.58 på port 6514 över TCP. Forward-regeln har inget filter, så alla meddelanden som når den skickas vidare. Det enda som stoppas innan är cloud-inits egna meddelanden. Anslutningen är etablerad.

**Belägg (konfiguration):**
```
konfiguration, /etc/rsyslog.d
action(
    type="omfwd"
    target="172.20.1.58"
    port="6514"
    protocol="tcp"
    ...
)
```

**Belägg (aktiv anslutning):**
```bash
[student@elev-28 ~]$ ss -tnp | grep 6514
ESTAB 0      0       172.20.1.128:46068  172.20.1.58:6514
```

### 2.2 Kryptering och autentisering

**Påstående:**

Trafiken krypteras med TLS (StreamDriver="gtls"), och StreamDriverMode="1" gör TLS obligatoriskt så att rsyslog inte skickar i klartext. Min server verifierar loggserverns certifikat mot kursens CA (ca.pem) och kontrollerar att namnet i certifikatet är log.sec.chas-lab.dev (x509/name). En falsk mottagare kan därför inte ta emot mina loggar.

**Belägg:**
```
global(
    DefaultNetstreamDriverCAFile="/etc/pki/rsyslog/ca.pem"
)
action(
    ...
    StreamDriver="gtls"
    StreamDriverMode="1"
    StreamDriverAuthMode="x509/name"
    StreamDriverPermittedPeers="log.sec.chas-lab.dev"
    ...
)

```

### 2.3 Skydd hos mottagaren

**Påstående:**

Från elev-28 kan jag bara skicka loggar till loggservern, inte logga in på den eller ändra det som redan tagits emot. En angripare som tar över min server får alltså inte åtkomst till de centrala kopiorna.

**Belägg:**
```
Jag har ingen åtkomst till servern

```

### 2.4 Test: loggrad når fram
**Belägg:**
```bash
# På min server:
[student@elev-28 ~]$ logger "loggyloggy-$(date +%s)"

# På mottagaren:
[elev-28@jump ~]$ loggsök "loggyloggy"
mottaget 2026-11-05T17:02:13.899Z TLS      | 2026-11-05T17:02:13+00:00 172.20.1.128 elev-28 student[101048]: loggyloggy-1793898133

```

---

## 3. Lagringstid / rotation

### 3.1 Rotation lokalt

**Belägg:**
```bash
[student@elev-28 ~]$ cat /etc/logrotate.conf
# see "man logrotate" for details

# global options do not affect preceding include directives

# rotate log files weekly
weekly

# keep 4 weeks worth of backlogs
rotate 4

# create new (empty) log files after rotating old ones
create

# use date as a suffix of the rotated file
dateext

# uncomment this if you want your log files compressed
#compress

# packages drop log rotation information into this directory
include /etc/logrotate.d

# system-specific logs may be also be configured here.

```
```bash
[student@elev-28 ~]$ cat /etc/logrotate.d/rsyslog
/var/log/cron
/var/log/maillog
/var/log/messages
/var/log/secure
/var/log/spooler
{
    missingok
    sharedscripts
    postrotate
        /usr/bin/systemctl -s HUP kill rsyslog.service >/dev/null 2>&1 || true
    endscript
}
```

### 3.2 Journald-gränser

**Belägg:**
```bash
[student@elev-28 ~]$ journalctl --disk-usage
Archived and active journals take up 38.1M in the file system.

```

### 3.3 Lagringstid centralt

**Påstående:**

Påstående: auditd roterar själv: varje fil får bli 8 MB och 5 filer sparas. När den femte är full skrivs den äldsta över. Lokalt finns alltså högst cirka 40 MB auditloggar, och hur långt bakåt det räcker beror på hur mycket som händer.

**Belägg:**
```
sudo cat /etc/audit/auditd.conf

freq = 50
max_log_file = 8
num_logs = 5
priority_boost = 4
name_format = NONE
##name = mydomain
max_log_file_action = ROTATE

```

---

## 4. Onåbar mottagare

### 4.1 Beteende vid avbrott

**Påstående:**

Min server köar överföringen av logs vid avbrott

**Belägg (konfiguration):**
```
# t.ex.
# queue.type="LinkedList"
# queue.filename="fwd_queue"
# queue.maxDiskSpace="..."
# queue.saveOnShutdown="on"
# action.resumeRetryCount="-1"
```

---

## 5. Bevisförstöringsscenario


### 5.1 Angriparens åtgärder och utfall

En angripare har fått root på min server och försöker gömma sina spår

Angriparens åtgärd: Raderar eller ändrar på /var/log/secure eller var/log/messages
Vad förstörs?: Lokala loggar
Vad klarar sig: Allt som redan har skickats till 
Varför: Angriparen har inte tillgång till loggservern

Angriparens åtgärd: Startar om servern
Vad förstörs: Hela journalen
Vad klarar sig: Textloggar på disk och andra kopior
Varför: Journalen finns bara i RAM

Angriparens åtgärd: Stoppar rsyslog
Vad förstörs: Allt som loggas efter stoppet når aldrig loggservern
Vad klarar sig: Allt som skickats innan
Varför: Inget skickas vidare när rsyslog inte kör

### 5.2 Upptäckt

Om angriparen stoppar rsyslog blir det tyst från 172.20.1.128 på loggservern. Det syns bara om någon har ett larm eller en detektion på att en server slutat skicka.

### 5.3 Svagheter och förbättringar

- Skapa /var/log/journal och sätt Storage=persistent i /etc/systemd/journald.conf för att få persistent logs
- Inget klient certifikat på servern
- Öka hur länge loggar sparas till 6 månader som NCSC rekommenderar

---