# Metodbilaga – härdningsrapport, workshop 2

## 1. Underlag som matades in

### Härdningslista

# X11 Forwarding

## Åtgärd

Stäng av x11 Forwarding genom att editera /etc/ssh/sshd_config.d/50-redhat.conf och ändra 
X11Forwarding yes till X11Forwarding no. Bättre alternativ är att göra en ny .conf fil med X11Forwarding no. Sen kör sudo systemctl reload sshd för att verkställa.

## Motivation

Jag kör inga program som kräver ett GUI


## Förväntad effekt

Jag kan inte längre köra GUI program via x11 Forwarding


## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '

permitrootlogin without-password /etc/ssh/sshd_config.d/10-labb.conf
pubkeyauthentication yes /Built-in default
passwordauthentication yes /etc/ssh/sshd_config.d/10-labb.conf
x11forwarding no <------ NYA ÄNDRINGEN

## Script?

NEJ

# Root login över SSH

## Åtgärd

Root login. Lämnas som den är (PermitRootLogin prohibit-password i /etc/ssh/sshd_config)

## Motivation

Jag behöver inte kunna logga in som root över SSH för det lämnar en mycket bred attackyta

## Förväntad effekt

Ingen kan logga in som root över ssh med lösenord, men med nyckel går det

## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '
permitrootlogin without-password <--------- SAMMA VALUE sätts i /etc/ssh/sshd_config.d/10-labb.conf 
pubkeyauthentication yes <------- Built in default
passwordauthentication yes <------/etc/ssh/sshd_config.d/10-labb.conf
x11forwarding no 

## Script?

NEJ

# pubkeyauthentication över SSH

## Åtgärd

Ingen ändring

## Motivation

Jag behöver kunna logga in och verifiera mig med min pubkey

## Förväntad effekt

Ingen

## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '
permitrootlogin without-password <---------etc/ssh/sshd_config.d/10-labb.conf 
pubkeyauthentication yes <------- Built in default
passwordauthentication yes <------ /etc/ssh/sshd_config.d/10-labb.conf
x11forwarding no 

## Script?

NEJ

# passwordauthentication över SSH

## Åtgärd

Ingen ändring

## Motivation

Jag behöver kunna logga in och verifiera mig med min pubkey

## Förväntad effekt

Ingen

## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '
permitrootlogin without-password <---------/etc/ssh/sshd_config.d/10-labb.conf 
pubkeyauthentication yes <------- Built in default
passwordauthentication yes <------/etc/ssh/sshd_config.d/10-labb.conf
x11forwarding no 

## Script?

NEJ

### sestatus

```
[student@elev-28 policy]$ sestatus
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

### semodule -l

```
[student@elev-28 policy]$ sudo semodule -l
abrt
accountsd
acct
afs
afterburn
aiccu
aide
ajaxterm
alsa
amanda
amtu
anaconda
antivirus
apache
apcupsd
apm
application
arpwatch
asterisk
auditadm
authconfig
authlogin
automount
avahi
awstats
bacula
base
bcfg2
bind
bitlbee
blkmapd
blueman
bluetooth
boinc
boltd
boothd
bootloader
bootupd
brctl
brltty
bugzilla
bumblebee
cachefilesd
calamaris
callweaver
canna
ccs
cdrecord
certmaster
certmonger
certwatch
cfengine
cgroup
chrome
chronyd
cinder
cipe
clock
clogd
cloudform
cmirrord
cobbler
collectd
colord
comsat
condor
conman
conntrackd
consolekit
coreos_installer
couchdb
courier
cpucontrol
cpufreqselector
cpuplug
cron
ctdb
cups
cvs
cyphesis
cyrus
daemontools
dbadm
dbskk
dbus
dcc
ddclient
denyhosts
devicekit
dhcp
dictd
dirsrv
dirsrv-admin
dmesg
dmidecode
dnsmasq
dnssec
dovecot
drbd
dspam
entropyd
exim
fail2ban
fcoe
fdo
fetchmail
finger
firewalld
firewallgui
firstboot
fprintd
freeipmi
freqset
fstools
ftp
fwupd
games
gdomap
geoclue
getty
git
gitosis
glance
gnome
gpg
gpm
gpsd
gssproxy
guest
hddtemp
hostapd
hostname
hsqldb
hwloc
hypervkvp
ibacm
ica
icecast
iiosensorproxy
inetd
init
inn
insights_client
iodine
iotop
ipmievd
ipsec
iptables
irc
irqbalance
iscsi
isns
jabber
jetty
jockey
journalctl
kdump
kdumpgui
keepalived
kerberos
keyboardd
keystone
kismet
kmscon
kpatch
ksmtuned
ktalk
l2tp
ldap
libraries
likewise
linuxptp
lircd
livecd
lldpad
loadkeys
locallogin
lockdev
logadm
logging
logrotate
logwatch
lpd
lsm
lttng-tools
lvm
mailman
mailscanner
man2html
mandb
mcelog
mediawiki
memcached
milter
minidlna
minissdpd
mip6d
mirrormanager
miscfiles
mock
modemmanager
modutils
mojomojo
mon_statd
mongodb
motion
mount
mozilla
mpd
mplayer
mptcpd
mrtg
mta
munin
mysql
mythtv
naemon
nagios
namespace
ncftool
netlabel
netutils
networkmanager
ninfod
nis
nova
nscd
nsd
nslcd
ntop
ntp
numad
nut
nvme_stas
nx
obex
oddjob
opafm
openct
opendnssec
openfortivpn
openhpid
openshift
openshift-origin
opensm
openvpn
openvswitch
openwsman
oracleasm
osad
pads
passenger
pcmcia
pcp
pcscd
pdns
pegasus
permissivedomains
pesign
pingd
piranha
pkcs
pkcs11proxyd
pki
plymouthd
podsleuth
policykit
polipo
portmap
portreserve
postfix
postgresql
postgrey
powerprofiles
ppp
prelink
prelude
privoxy
procmail
prosody
psad
ptchown
publicfile
pulseaudio
puppet
pwauth
qatlib
qgs
qmail
qpid
quantum
quota
rabbitmq
radius
radvd
raid
rasdaemon
rdisc
readahead
realmd
redis
remotelogin
rhcd
rhcs
rhev
rhgb
rhnsd
rhsmcertd
ricci
rkhunter
rkt
rlogin
rngd
rolekit
roundup
rpc
rpcbind
rpm
rrdcached
rshd
rshim
rssh
rsync
rtas
rtkit
rwho
samba
sambagui
sandboxX
sanlock
sap
sasl
sbd
sblim
screen
secadm
sectoolm
selinuxutil
sendmail
sensord
setrans
setroubleshoot
seunshare
sge
shorewall
slocate
slpd
smartmon
smokeping
smoltclient
smsd
snapper
snmp
snort
sosreport
soundserver
spamassassin
speech-dispatcher
squid
ssh
sslh
sssd
staff
stalld
stapserver
stratisd
stunnel
su
sudo
svnserve
swift
switcheroo
sysadm
sysadm_secadm
sysnetwork
sysstat
systemd
tangd
targetd
tcpd
tcsd
telepathy
telnet
tftp
tgtd
thin
thumb
timedatex
tlp
tmpreaper
tomcat
tor
tuned
tvtime
udev
ulogd
uml
unconfined
unconfineduser
unlabelednet
unprivuser
updfstab
usbmodules
usbmuxd
userdomain
userhelper
usermanage
usernetctl
uucp
uuidd
varnishd
vdagent
vhostmd
virt
vlock
vmtools
vmware
vnstatd
vpn
w3c
watchdog
wdmd
webadm
webalizer
wine
wireguard
wireshark
xen
xguest
xserver
zabbix
zarafa
zebra
zoneminder
zonvakt
zosremote
```

### Verifieringsskriptets utdata

```
Gäller : X-11 Forwarding = No
Gäller: Password Authentication = Yes
Gäller: Enforcing
```

## 2. Prompt

```
Ok you are gonna do the ai utkast now
```

Prompten skickades tillsammans med underlaget i avsnitt 1.

## 3. Råsvar

**Härdningsrapport – elev-28 (utkast)**

**1. Sammanfattning**
Servern kör SELinux i enforcing-läge med targeted-policy, och den egna tjänsten zonvakt körs i en egen domän (`zonvakt_t`) under en laddad policymodul. SSH-konfigurationen har skärpts genom att X11Forwarding stängts av. Root-inloggning med lösenord är blockerad. Lösenordsinloggning för vanliga användare är fortfarande tillåten, och det är den största kvarstående risken i SSH-konfigurationen.

**2. SELinux**
- SELinux är aktiverat (`SELinux status: enabled`) och körs i enforcing (`Current mode: enforcing`).
- Läget i konfigurationsfilen är också enforcing, så läget ligger kvar efter omstart.
- Laddad policy är `targeted`, och MLS-stöd är aktiverat i policyn.
- `deny_unknown` är `allowed`, vilket betyder att klasser och behörigheter som policyn inte känner till tillåts i stället för att nekas.
- Den egna modulen `zonvakt` finns bland de laddade modulerna i `semodule -l`.

**3. Processdomäner**
- zonvakt (PID 1017) körs som `system_u:system_r:zonvakt_t:s0`. Tjänsten är alltså begränsad av sin egen policy och körs inte som `unconfined_service_t`.
- Centrala systemtjänster körs i sina standarddomäner: sshd i `sshd_t`, httpd i `httpd_t`, rsyslogd och systemd-journal i `syslogd_t`, auditd i `auditd_t` och chronyd i `chronyd_t`.
- Ingen systemtjänst i listan körs i en okonfinerad domän.
- Den inloggade användarens session (bash, sshd-session) körs i `unconfined_t`. Det är standard för targeted-policyn och påverkar inte tjänsternas isolering.
- Apache (httpd) körs med fem processer. Tjänsten finns inte med i härdningslistan, så det bör utredas om den behövs.

**4. SSH-konfiguration**

| Inställning | Värde | Källa | Bedömning |
|---|---|---|---|
| X11Forwarding | no | ny drop-in-fil | Åtgärdad. Minskar attackytan eftersom ingen GUI-vidarebefordran behövs. |
| PermitRootLogin | without-password | 10-labb.conf | Root kan inte logga in med lösenord men kan fortfarande logga in med nyckel. |
| PubkeyAuthentication | yes | inbyggt standardvärde | Behövs för nyckelinloggning. |
| PasswordAuthentication | yes | 10-labb.conf | Rekommenderas att sättas till no, eftersom inloggning sker med nyckel. |

- Att lägga ändringen i en egen .conf-fil i stället för att redigera 50-redhat.conf är bättre, eftersom ändringen då inte skrivs över vid paketuppdateringar.
- `sshd -T` visar den faktiska, sammanslagna konfigurationen och är därför rätt kommando för verifiering.
- `without-password` är ett äldre alias för `prohibit-password`.

**5. Verifieringsskript**
Skriptet kontrollerar tre saker: att X11Forwarding är no, att PasswordAuthentication är yes, och att SELinux är i enforcing. Det kontrollerar inte PermitRootLogin och inte att zonvakt körs i `zonvakt_t`. Båda bör läggas till för att skriptet ska täcka hela härdningslistan.

**6. Rekommendationer**
1. Sätt `PasswordAuthentication no` i en drop-in-fil och kör `systemctl reload sshd`.
2. Överväg `PermitRootLogin no` om root-inloggning med nyckel inte behövs.
3. Utred om httpd behövs. Annars stoppar och inaktiverar du tjänsten.
4. Bygg ut verifieringsskriptet med kontroller för PermitRootLogin och zonvakts domän.

## 4. Rättelselogg


### Sammanfattning

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
| 10 | X11Forwarding kommer från en ny drop-in-fil | Stämmer inte | Fel källa: distributionens drop-in `50-redhat.conf`, som jag ändrade, inte en ny |
| 11 | PermitRootLogin är `without-password`, från `10-labb.conf` | Stämmer | Inget |

---

### Nr 0

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

### Nr 1

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

### Nr 2

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

### Nr 3

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

### Nr 4

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

### Nr 5

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

### Nr 6

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

### Nr 7

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

### Nr 8

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

### Nr 9

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

### Nr 10

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

### Nr 11

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

## 5. Utelämningslista

Informationen som ska maskeras inkluderar ip adresser, lösenord, och nycklar. Privata adresser har inte maskerats i detta fall då dessa inte är routable över internet, och i detta fall i ett lab nätverk. I produktikion bör dock även dessa adresser maskeras då de identifierar strukturen av kundens system.