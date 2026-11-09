# Skyddsbeskrivning: loggkedja

Server: elev-42
IP-adress: 10.40.7.2 
Loggserver: 172.20.1.58 (log.sec.chas-lab.dev)
Datum: 2026-11-06

## 1. Lokalt

Påstående:

Servern använder journald, rsyslog och auditd för att samla in loggar. Rsyslog sparar loggar i /var/log/messages och /var/log/secure. Filerna ägs av root och vanliga användare kan inte ändra dem.

Belägg:
systemctl status rsyslog
systemctl status auditd
systemctl status systemd-journald
ls -l /var/log/messages /var/log/secure

## 2. Journal

Påstående:

Journalen sparas bara tillfälligt i minnet eftersom /var/log/journal saknas. Därför försvinner den vid omstart.

Belägg:
ls -ld /var/log/journal
journalctl --list-boots

## 3. Central loggning

Påstående:

Min server skickar loggar till kursens loggserver på port 6514 med TLS. Det betyder att loggarna är krypterade när de skickas. Servern kontrollerar också loggserverns certifikat.

Belägg:
sudo cat /etc/rsyslog.d/50-tls.conf
ss -tnp | grep 6514

## 4. Lagring och kö

Påstående:

Loggarna sparas i fyra veckor och roteras varje vecka. Auditd sparar fem loggfiler på 8 MB vardera.

Rsyslog har också en kö på disk. Om loggservern inte fungerar försöker den skicka loggarna igen senare.

Belägg:
cat /etc/logrotate.conf
sudo cat /etc/audit/auditd.conf
sudo cat /etc/rsyslog.d/50-tls.conf

## 5. Bevisförstöring och svagheter

Påstående:

Om någon får root på min server kan personen ändra eller ta bort lokala loggar. Loggar som redan skickats till den centrala servern finns dock kvar.

Om servern startas om försvinner journalen eftersom den bara sparas i minnet.

En annan svaghet är att auditd inte har några aktiva regler just nu.

