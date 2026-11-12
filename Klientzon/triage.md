



# Triagepost T-01

**ID:** T-01  
**Tid:** 2026-11-03 10:52:01 UTC  
**Monitor/regel:** Rule ID 5710  
**Agent/källa:** elev-28, `/var/log/remote/elev-28/syslog.log`

## OBSERVATION

- **Source IP:** 172.20.1.2
- **User:** students
- **Number of events:** 15 (firedtimes). Tidsintervall ej verifierat.
- **Loggrad:** `Failed password for invalid user students from 172.20.1.2 port 53696 ssh2`
- **Search without host filter:** `rule.id: 5710 AND data.srcip: "172.20.1.2"`
- **Resultat:** Ej kontrollerat.

## SLUTSATS

**Vad hände:** Misslyckat SSH-inloggningsförsök med ett ogiltigt användarnamn.

**Vad berördes:** Server elev-28, SSH och användaren students.

**Bedömning:** Hot, misstänkt aktivitet.

**Skäl:** Regel 5710 registrerade ett försök från 172.20.1.2 med ett användarnamn som inte finns.

**Vad ska göras:** Kontrollera om IP-adressen är godkänd och sök efter liknande försök på andra servrar. Eskalera om aktiviteten är obehörig.




# Triagepost T-02

**ID:** T-02  
**Tid:** 2026-11-10 07:42:29 UTC  
**Monitor/regel:** Rule ID 5402  
**Agent/källa:** elev-28, `/var/log/remote/elev-28/syslog.log`

## OBSERVATION

- **Source IP:** Ej angiven i loggen.
- **User:** student
- **Target user:** root
- **Command:** `/bin/cat /etc/nftables/zon.nft`
- **Number of events:** 1 (`firedtimes: 1`)
- **Loggrad:** `student : TTY=pts/2 ; PWD=/home/student ; USER=root ; COMMAND=/bin/cat /etc/nftables/zon.nft`
- **Search without host filter:** Ej kontrollerat.

## SLUTSATS

**Vad hände:** Studenten använde sudo för att läsa brandväggens konfigurationsfil.

**Vad berördes:** Server elev-28 och filen `/etc/nftables/zon.nft`.

**Bedömning:** Legitimt, förutsatt att kommandot ingick i det tilldelade arbetet.

**Skäl:** Loggen visar ett enstaka sudo-kommando från student till root för att läsa en konfigurationsfil.

**Vad ska göras:** Ingen åtgärd om kommandot var en del av labbuppgiften. Dokumentera som legitim aktivitet.


# Triagepost T-03

**ID:** T-03  
**Tid:** 2026-11-09 14:19:44 UTC  
**Monitor/regel:** nftables outbound/inbound drop log, ingen Rule ID angiven  
**Agent/källa:** elev-28, `/var/log/remote/elev-28/syslog.log`

## OBSERVATION

- **Source IP:** 10.40.7.2
- **Destination IP:** 10.40.7.89
- **Protocol:** TCP
- **Source port:** 33548
- **Destination port:** 10000
- **Interface:** eth2
- **Loggrad:** `nft-drop-in IN=eth2 SRC=10.40.7.2 DST=10.40.7.89 PROTO=TCP SPT=33548 DPT=10000 SYN`
- **Search without host filter:** Ej kontrollerat.

## SLUTSATS

**Vad hände:** Brandväggen loggade ett inkommande TCP-anslutningsförsök från 10.40.7.2 till port 10000 på 10.40.7.89.

**Vad berördes:** Server elev-28, nätverksgränssnitt eth2 och destination port 10000.

**Bedömning:** Misstänkt aktivitet, behöver undersökas.

**Skäl:** Loggen innehåller prefixet `nft-drop-in`, vilket indikerar att brandväggens loggregel registrerade trafiken som inkommande drop-trafik. TCP SYN-paketet visar ett anslutningsförsök.

**Vad ska göras:** Kontrollera om 10.40.7.2 är en godkänd källa och om trafik till port 10000 är förväntad. Sök efter fler försök från samma IP. Om trafiken är obehörig, behåll blockeringen och dokumentera händelsen.



# Triagepost T-04

**ID:** T-04  
**Tid:** 2026-11-06 08:33:38 UTC  
**Monitor/regel:** Outbound Attempt, nft-drop-out  
**Agent/källa:** elev-28, `/var/log/remote/elev-28/syslog.log`

## OBSERVATION

- **Source IP:** 10.40.7.89
- **Destination IP:** 10.40.7.2
- **Protocol:** TCP
- **Source port:** 37548
- **Destination port:** 8080
- **Action:** nft-drop-out
- **Loggrad:** `nft-drop-out IN= OUT=eth2 SRC=10.40.7.89 DST=10.40.7.2 PROTO=TCP SPT=37548 DPT=8080 SYN`
- **Search without host filter:** Ej kontrollerat.

## SLUTSATS

**Vad hände:** Servern försökte skapa en utgående TCP-anslutning till port 8080. Brandväggen loggade och blockerade försöket.

**Vad berördes:** elev-28, IP 10.40.7.89 och destination 10.40.7.2 på port 8080.

**Bedömning:** Misstänkt aktivitet, behöver undersökas.

**Skäl:** nftables registrerade trafiken med prefixet `nft-drop-out`. TCP SYN visar ett anslutningsförsök.

**Vad ska göras:** Kontrollera vilket program som försökte ansluta och om destinationen är godkänd. Ingen brandväggsregel bör ändras innan trafiken har verifierats.



## Monitor T-01 – SSH failed login (Rule 5710)

**Search:** `location: /var/log/remote/elev-42/syslog.log`

**Monitor filters:** `rule.id: 5710 AND location: /var/log/remote/elev-42/syslog.log`

**Trigger:** More than 8 attempts

**Trigger it with:** More than 8 failed SSH login attempts.

**Edge case that shouldn't match:** 8 or fewer attempts.



## Monitor T-02 – nft-drop-in

**Search:** `location: /var/log/remote/elev-42/syslog.log`

**Monitor filters:** `data.action: nft-drop-in AND location: /var/log/remote/elev-42/syslog.log`

**Trigger:** More than 0

**Trigger it with:** 1 nft-drop-in event.

**Edge case that shouldn't match:** No nft-drop-in events.



## Monitor T-03 – Sudo command (Rule 5402)

**Search:** `location: /var/log/remote/elev-42/syslog.log`

**Monitor filters:** `rule.id: 5402 AND location: /var/log/remote/elev-42/syslog.log`

**Trigger:** More than 0

**Trigger it with:** 1 sudo command.

**Edge case that shouldn't match:** No sudo commands.



## Monitor T-04 – nft-drop-out

**Search:** `location: /var/log/remote/elev-42/syslog.log`

**Monitor filters:** `data.action: nft-drop-out AND location: /var/log/remote/elev-42/syslog.log`

**Trigger:** More than 0

**Trigger it with:** 1 nft-drop-out event.

**Edge case that shouldn't match:** No nft-drop-out events.



# Playbook T-01: SSH Brute Force / Failed Login

## 1. Syfte

Identifiera och hantera upprepade misslyckade SSH-inloggningsförsök som kan tyda på brute-force eller obehöriga inloggningsförsök.

## 2. Trigger

- **Rule ID:** 5710
- **Loggkälla:** `/var/log/remote/elev-42/syslog.log`
- **Monitor filter:** `rule.id: 5710 AND location: /var/log/remote/elev-42/syslog.log`
- **Trigger condition:** More than 8 attempts.
- **Trigger it with:** Mer än 8 misslyckade SSH-inloggningsförsök.
- **Edge case:** 8 eller färre försök ska inte trigga.

## 3. Undersökning

1. Identifiera käll-IP-adressen.
2. Kontrollera vilket användarnamn som användes.
3. Räkna antalet misslyckade inloggningsförsök.
4. Kontrollera om samma IP-adress har försökt logga in på andra servrar.
5. Kontrollera om det finns lyckade inloggningar från samma IP-adress.
6. Bedöm om aktiviteten är legitim eller obehörig.

## 4. Åtgärder

- Om IP-adressen är godkänd: dokumentera händelsen.
- Om aktiviteten är misstänkt: informera ansvarig administratör.
- Om aktiviteten är obehörig: följ organisationens rutin för blockering av käll-IP.
- Kontrollera om några konton har komprometterats.

## 5. Eskalering

Eskalera till säkerhetsansvarig om det finns tecken på lyckad obehörig inloggning eller fortsatta attacker.

## 6. Dokumentation

Dokumentera:

- Käll-IP.
- Använt användarnamn.
- Antal försök.
- Berörd server.
- Resultat av undersökningen.
- Vidtagna åtgärder.

---

# Playbook T-02: nftables Inbound Drop

## 1. Syfte

Identifiera och undersöka inkommande nätverkstrafik som har blockerats av nftables.

## 2. Trigger

- **Monitor:** nft-drop-in
- **Loggkälla:** `/var/log/remote/elev-42/syslog.log`
- **Monitor filter:** `data.action: nft-drop-in AND location: /var/log/remote/elev-42/syslog.log`
- **Trigger condition:** More than 0.
- **Trigger it with:** 1 nft-drop-in event.
- **Edge case:** Inga nft-drop-in-händelser ska inte trigga.

## 3. Undersökning

1. Identifiera käll-IP och destinations-IP.
2. Kontrollera vilket nätverksgränssnitt som tog emot trafiken.
3. Identifiera protokoll och destinationsport.
4. Kontrollera om käll-IP-adressen är godkänd.
5. Undersök om samma källa har genererat fler blockerade anslutningsförsök.
6. Kontrollera om trafiken är förväntad enligt nätverkets regler.

## 4. Åtgärder

- Om trafiken är förväntad: dokumentera händelsen.
- Om trafiken är okänd: undersök källan och destinationen vidare.
- Om trafiken är obehörig: behåll befintlig blockering.
- Kontrollera om andra system har utsatts för liknande trafik.

## 5. Eskalering

Eskalera om trafiken tyder på portskanning, upprepade anslutningsförsök eller försök att nå otillåtna tjänster.

## 6. Dokumentation

Dokumentera:

- Käll-IP.
- Destinations-IP.
- Protokoll.
- Källport och destinationsport.
- Nätverksgränssnitt.
- Undersökningsresultat.
- Vidtagna åtgärder.

---

# Playbook T-03: Sudo Privilege Usage

## 1. Syfte

Identifiera och undersöka användning av sudo för att upptäcka obehörig eller oväntad privilegiehöjning.

## 2. Trigger

- **Rule ID:** 5402
- **Loggkälla:** `/var/log/remote/elev-42/syslog.log`
- **Monitor filter:** `rule.id: 5402 AND location: /var/log/remote/elev-42/syslog.log`
- **Trigger condition:** More than 0.
- **Trigger it with:** 1 sudo-kommando.
- **Edge case:** Inga sudo-kommandon ska inte trigga.

## 3. Undersökning

1. Identifiera användaren som körde sudo.
2. Kontrollera vilket konto kommandot kördes som.
3. Identifiera det exakta kommandot.
4. Kontrollera vilken fil eller tjänst som påverkades.
5. Kontrollera om kommandot ingick i en godkänd arbetsuppgift.
6. Undersök om fler privilegierade kommandon kördes i samma session.

## 4. Åtgärder

- Om kommandot var godkänt: dokumentera som legitim aktivitet.
- Om kommandot är oväntat: kontakta ansvarig administratör.
- Om kommandot verkar obehörigt: undersök användarkontot och dess behörigheter.
- Kontrollera om systemkonfigurationer har ändrats.

## 5. Eskalering

Eskalera om användaren har utfört obehöriga administrativa ändringar eller om kontot misstänks vara komprometterat.

## 6. Dokumentation

Dokumentera:

- Användarnamn.
- Målkonto.
- Kommando.
- Berörd fil eller tjänst.
- Tidpunkt.
- Om aktiviteten var godkänd.
- Vidtagna åtgärder.

---

# Playbook T-04: nftables Outbound Drop

## 1. Syfte

Identifiera och undersöka utgående nätverkstrafik som har blockerats av nftables.

## 2. Trigger

- **Monitor:** nft-drop-out
- **Loggkälla:** `/var/log/remote/elev-42/syslog.log`
- **Monitor filter:** `data.action: nft-drop-out AND location: /var/log/remote/elev-42/syslog.log`
- **Trigger condition:** More than 0.
- **Trigger it with:** 1 nft-drop-out event.
- **Edge case:** Inga nft-drop-out-händelser ska inte trigga.

## 3. Undersökning

1. Identifiera vilken server som försökte skapa anslutningen.
2. Kontrollera destinations-IP och destinationsport.
3. Identifiera protokoll och nätverksgränssnitt.
4. Undersök vilket program eller vilken tjänst som kan ha initierat anslutningen.
5. Kontrollera om destinationen är godkänd.
6. Sök efter fler utgående anslutningsförsök till samma destination.

## 4. Åtgärder

- Om trafiken är legitim: dokumentera händelsen.
- Om destinationen är okänd: undersök processen som initierade anslutningen.
- Om trafiken är obehörig: behåll blockeringen.
- Kontrollera om det finns tecken på skadlig programvara eller oönskad kommunikation.

## 5. Eskalering

Eskalera om trafiken kan tyda på misstänkt extern kommunikation, dataläckage eller kommunikation med en obehörig tjänst.

## 6. Dokumentation

Dokumentera:

- Käll-IP.
- Destinations-IP.
- Protokoll.
- Källport och destinationsport.
- Nätverksgränssnitt.
- Eventuell identifierad process.
- Undersökningsresultat.
- Vidtagna åtgärder.
