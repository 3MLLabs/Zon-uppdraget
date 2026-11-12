# Milstolpe 6 – elev-40 (webb, 10.40.7.66)

Fyra larm i Wazuh, en triagelogg och en playbook per larm.

## 1. Larmen

Alla larm körs varje minut och tittar på de senaste 5 minuterna.

| Larm | Vad det betyder | Index | Larmar vid |
|---|---|---|---|
| **T1110** brute force | Någon försöker logga in med konton som inte finns. | alerts | 5 eller fler |
| **TA0008** zonöverträdelse | En server i teamet försöker nå en annan på en väg som inte är tillåten. | archives | 1 eller fler |
| **T1548.003** root-kommando | En människa kör ett program som root. | archives | 1 eller fler |
| **T1562.004** brandväggen ändras | Någon ändrar filerna i /etc/nftables. | archives | 1 eller fler |

### Vad larmen söker på

| Larm | Sökning | Ska inte larma på |
|---|---|---|
| T1110 | `location: *elev-40*` och `rule.id` 5710/5712 | Feltryckning på ett konto som finns (ger regel 5760) |
| TA0008 | `data.action: ZON*` och teamets adresser (.2 .66 .73 .89) | Labbnätet 172.20.x och skannrar från internet |
| T1548.003 | `audisp-syslog` och `root-cmd` | Cron-jobb och `grub2-set-bootflag` vid inloggning |
| T1562.004 | `audisp-syslog` och `nft-andring` | Reglerna laddas vid start (`AUID="unset"`) |

### Brus (larm som inte är attacker)

| Larm | Mätt tid | Träffar | Risk för falsklarm |
|---|---|---|---|
| T1110 | 24 timmar | 10, i en skur = 1 larm | Låg |
| TA0008 | 168 timmar | 0 | Låg |
| T1548.003 | 336 timmar | 127, mitt eget arbete | Medel när jag arbetar som admin |
| T1562.004 | 336 timmar | 3 | Låg |

### Test (11/11)

| Larm | Vad jag gjorde | Larmade? |
|---|---|---|
| T1110 | ctf-testet U6.2 kl. 09:53 | Ja |
| TA0008 | `nc` från webben till databasen kl. 11:20 | Ja |
| T1548.003 | `sudo id` kl. 10:18 | Ja |
| T1562.004 | `sudo touch /etc/nftables/zon.nft` kl. 10:30 | Ja |

## 2. Triagelogg (12/11, tider i UTC)

| Tid | Larm | Vad jag såg | Slutsats | Beslut |
|---|---|---|---|---|
| 11/11 08:53 | T1110 | 12 försök från 172.20.1.10 med påhittade namn. Ingen kom in. | ctf testade min server. | Avfärda. Skäl: U6.2 startades då. |
| 12/11 08:41 | T1110 | Försöken gällde elev-28, inte min server. | Mitt larm räknade teamets loggar. | Avfärda. Jag lade till `location: *elev-40*` i larmet. |
| 12/11 08:52 | T1110 (inget larm) | 4 försök från mig. | Under gränsen 5. | Rätt att inget larm kom. |
| 12/11 08:53 | TA0008 | Webben försökte nå databasen på port 5432. Brandväggen stoppade det. | Mitt test. | Avfärda. Skäl: mitt `nc` vid samma tid. |
| 12/11 08:54 | T1548.003 | Jag körde dnf och touch som root. | Mitt adminarbete. | Avfärda. Skäl: min session och mina anteckningar. |
| 12/11 08:55 | T1562.004 | touch på zon.nft. Reglerna är oförändrade. | Mitt test. | Avfärda. Skäl: `nft list ruleset` är samma som i repot. |

## 3. Playbooks

Samma steg för alla larm. Fas från NIST står i hakparentes.

**Alla larm börjar så här:**
1. [Förberedelse] Kontrollera att larmet är på (Alerting → Monitors).
2. [Analys] Öppna larmet och klicka på **Acknowledge**. Skriv ner tiden. UTC = svensk tid − 1 timme.
3. [Analys] Sök i Discover från 5 minuter före larmet fram till larmet.
4. [Efterarbete] Skriv en rad i triageloggen: vad jag såg, slutsats och beslut med skäl.

### T1110 brute force
- **Sök:** `location: *elev-40* and rule.id: (5710 or 5712)`. Skriv ner källa och konton.
- **Kolla källan:** 172.20.1.10 = ctf. 172.20.1.2 = jump. Annan adress = okänd.
- **Kom någon in?** Sök `rule.id: (5715 or 40112)` från samma källa. Sök `rule.id: 5902` (nytt konto).
- **Avfärda** om ingen kom in och det finns ett känt test.
- **Eskalera** om någon kom in, om ett nytt konto finns eller om källan är okänd.
- **Åtgärd** (efter beslut i teamet): blockera källan med nft och lås det nya kontot.

### TA0008 zonöverträdelse
- **Sök:** `location: *elev-40* and data.action: ZON*`. Skriv ner källa, mål och port.
- **UT-DROP** = min server försökte. **IN-DROP** = en annan server försökte.
- **Kolla flödestabellen.** Om flödet är tillåtet där är regeln fel, inte trafiken.
- **Avfärda** om det finns ett känt test med samma källa, mål och port.
- **Eskalera** om det inte finns något test, eller om många portar eller servrar provas.
- **Åtgärd:** ägaren av servern kontrollerar processer med `sudo ss -tnp`.

### T1548.003 root-kommando
- **Sök:** `audisp-syslog` och `root-cmd`. Läs `AUID`, `comm` och `tty`.
- **Normalt:** dnf, nft list och systemctl status.
- **Misstänkt:** useradd, passwd, nft flush och program från /tmp.
- **Avfärda** om kontot är känt och arbetet är planerat.
- **Eskalera** vid ett misstänkt kommando eller ett okänt konto.
- **Åtgärd:** lås kontot med `sudo usermod -L <konto>`.

### T1562.004 brandväggen ändras
- **Sök:** `audisp-syslog` och `nft-andring`. Läs `comm` och `AUID`.
- **Kolla reglerna:** jämför `sudo nft list ruleset` med Zon.nft i repot.
- **Avfärda** om ändringen var planerad och reglerna stämmer.
- **Eskalera** om det finns en ny `accept`-regel, om `policy drop` saknas eller om ändringen inte var planerad.
- **Åtgärd:** spara bevis och lägg tillbaka Zon.nft från repot. Testa med test.sh.
