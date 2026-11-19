# Rättelselogg – SELinux & SSH

## Sammanfattning

| Nr | Påstående | Dom | Feltyp |
|---|---|---|---|
| 0 | SELinux är aktiverat | Stämmer | Inget |
| 1 | Läget i konfigurationsfilen är `enforcing` | Stämmer | Inget |
| 2 | Laddad policy är `targeted`, MLS aktiverat | Stämmer | Inget |
| 3 | `deny_unknown` är `allowed` | Stämmer | Inget |
| 4 | Modulen `zonvakt` är laddad | Stämmer | Inget |
| 5 | zonvakt körs i `zonvakt_t` | Stämmer | Inget |
| 6 | Systemtjänster körs i standarddomäner | Stämmer | Inget |
| 7 | Ingen systemtjänst är okonfinerad | Stämmer | Inget |
| 8 | Användarsessionen körs i `unconfined_t` | Stämmer | Inget |
| 9 | Apache (httpd) körs med fem processer | Stämmer | Inget |
| 10 | X11Forwarding kommer från en ny drop-in-fil | Stämmer inte | Fel källa: distributionens drop-in, inte en ny |
| 11 | PermitRootLogin är `without-password`, från `10-labb.conf` | Stämmer | Inget |


## Maskering

Jag har kollat efter IP adresser, nycklar etc, innan jag skickade dessa till AI och hittade ingenting som skulle maskeras

---

## Nr 0

**Påstående:** SELinux är aktiverat.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
sestatus
```

**Faktiskt utfall:**
```
SELinux status: enabled
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 1

**Påstående:** Läget i konfigurationsfilen är också `enforcing`, så läget ligger kvar efter omstart.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
cat /etc/selinux/config
```

**Faktiskt utfall:**
```
SELINUX=enforcing
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 2

**Påstående:** Laddad policy är `targeted`, och MLS-stöd är aktiverat i policyn.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
sestatus
```

**Faktiskt utfall:**
```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 3

**Påstående:** `deny_unknown` är `allowed`, vilket betyder att klasser och behörigheter som policyn inte känner till tillåts i stället för att nekas.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
sestatus
```

**Faktiskt utfall:**
```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 4

**Påstående:** Den egna modulen `zonvakt` finns bland de laddade modulerna i `semodule -l`.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
sudo semodule -l | grep zonvakt
```

**Faktiskt utfall:**
```
zonvakt
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 5

**Påstående:** zonvakt (PID 1017) körs som `system_u:system_r:zonvakt_t:s0`. Tjänsten är alltså begränsad av sin egen policy och körs inte som `unconfined_service_t`.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
ps -eZ | grep zonvakt
```

**Faktiskt utfall:**
```
system_u:system_r:zonvakt_t:s0     1017 ?        00:00:00 zonvakt
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 6

**Påstående:** Centrala systemtjänster körs i sina standarddomäner: sshd i `sshd_t`, httpd i `httpd_t`, rsyslogd och systemd-journal i `syslogd_t`, auditd i `auditd_t` och chronyd i `chronyd_t`.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
ps -eZ | grep -E 'sshd|httpd|rsyslogd|systemd-journal|auditd|chronyd'
```

**Faktiskt utfall:**
```
system_u:system_r:kernel_t:s0        34 ?        00:00:00 kauditd
system_u:system_r:syslogd_t:s0      526 ?        00:00:02 systemd-journal
system_u:system_r:auditd_t:s0       597 ?        00:00:01 auditd
system_u:system_r:auditd_t:s0       599 ?        00:00:00 audisp-syslog
system_u:system_r:auditd_t:s0       600 ?        00:00:00 sedispatch
system_u:system_r:chronyd_t:s0      669 ?        00:00:00 chronyd
system_u:system_r:httpd_t:s0        728 ?        00:00:00 httpd
system_u:system_r:httpd_t:s0        769 ?        00:00:00 httpd
system_u:system_r:httpd_t:s0        770 ?        00:00:01 httpd
system_u:system_r:httpd_t:s0        771 ?        00:00:01 httpd
system_u:system_r:httpd_t:s0        772 ?        00:00:01 httpd
system_u:system_r:syslogd_t:s0      997 ?        00:00:05 rsyslogd
system_u:system_r:sshd_t:s0-s0:c0.c1023 1004 ?   00:00:00 sshd
system_u:system_r:sshd_t:s0-s0:c0.c1023 2410 ?   00:00:00 sshd-session
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 7

**Påstående:** Ingen systemtjänst i listan körs i en okonfinerad domän.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
ps -eZ | grep unconfined
```

**Faktiskt utfall:**
```
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 2999 ? 00:00:00 systemd
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 3041 ? 00:00:00 sshd-session
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 3049 pts/0 00:00:00 bash
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 5737 pts/0 00:00:00 ps
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 5738 pts/0 00:00:00 grep
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 8

**Påstående:** Den inloggade användarens session (bash, sshd-session) körs i `unconfined_t`. Det är standard för targeted-policyn och påverkar inte tjänsternas isolering.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
ps -eZ | grep unconfined
```

**Faktiskt utfall:**
```
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 3041 ? 00:00:00 sshd-session
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 9

**Påstående:** Apache (httpd) körs med fem processer. Tjänsten finns inte med i härdningslistan, så det bör utredas om den behövs.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
ps -eZ | grep -c httpd
```

**Faktiskt utfall:**
```
5
```

**Feltyp:** Inget
**Ändrat till:** Inget

---

## Nr 10

**Påstående:** X11Forwarding kommer från en ny drop-in-fil.

**Dom:** Stämmer inte

**Kommando som avgjorde:**
```bash
sudo cat /etc/ssh/sshd_config.d/50-redhat.conf
```

**Faktiskt utfall:**
```
X11Forwarding no
```

**Feltyp:** Fel källa. Inställningen kommer från `50-redhat.conf`, som följer med distributionen. Det är en drop-in-fil, men ingen ny.
**Ändrat till:** X11Forwarding är `no`, satt i distributionens medföljande drop-in-fil `50-redhat.conf`.

---

## Nr 11

**Påstående:** PermitRootLogin är `without-password`, från `10-labb.conf`.

**Dom:** Stämmer

**Kommando som avgjorde:**
```bash
sudo sshd -T | grep permitrootlogin
sudo grep -ri permitrootlogin /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
```

**Faktiskt utfall:**
```
permitrootlogin without-password
```
```
/etc/ssh/sshd_config:PermitRootLogin prohibit-password
/etc/ssh/sshd_config:# the setting of "PermitRootLogin prohibit-password".
/etc/ssh/sshd_config.d/10-labb.conf:PermitRootLogin prohibit-password

```

**Feltyp:** Inget
**Ändrat till:** Inget