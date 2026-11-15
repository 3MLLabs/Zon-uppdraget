# AI-användning vecka 45 (2–8 nov 2026)

## Logg

| Datum | Moment | Min fråga | AI förklarade | Egen insats |
| --- | --- | --- | --- | --- |
| 2026-11-08 | Vecka 6, milstolpe 6 | Vad krävs denna vecka? | Sammanfattade studieguiden: fyra Wazuh-detektioner med playbooks enligt NIST 800-61 | Planerade arbetet och tog över main i repot |
| 2026-11-08 | Zonuppdraget, vecka 5 | Vad ska mergas till main? | Mappstruktur per server; rättade fel zonnamn i en fil | Ansvarade för merge till main |
| 2026-11-08 | U5.5 | Var ställer jag in RFC 5424-format i rsyslog? | Mallen RSYSLOG\_SyslogProtocol23Format | Hittade själv lösningen hos Red Hat |
| 2026-11-06 | Vecka 5, repetition | Det som var oklart: config-filer, nftables, loggar | Studieguide och steg-för-steg om CA och TLS-certifikat | Gick igenom med kontrollfrågor |
| 2026-11-06 | Skyddsbeskrivning loggkedja | Var finns uppgiften och hur fyller jag i den? | Hittade instruktionen i Canvas, byggde mallar fyllda med min kommandoutdata | Körde alla kommandon på min server och granskade texten |
| 2026-11-05 | Loggning, Ö6 | Var lagrar journald loggar utan /var/log/journal? | /run/log/journal i RAM; journald och rsyslog loggar parallellt | Skrev eget svar, AI granskade mot facit |
| 2026-11-05 | auditd | Vad är uid, euid och auid? | auid följer inloggad användare även efter sudo; ausearch -ue vs -ge | Sökte själv i audit.log på elev-28 |
| 2026-11-05 | rsyslog | Skickas inloggningsloggar över TLS? | Selektorer (authpriv.\* vs kern.\*) och TLS-direktiv | Granskade konfigurationen i /etc/rsyslog.d/ |
| 2026-11-05 | journalctl | Varför syns inte blockerade anslutningar? | Trafik till egen IP går via loopback | Testade från jump |
| 2026-11-05 | Föreläsning MCFFS 2026:11 | Lär mig föreläsningen | Loggkrav i 4 kap., molnbrandvägg vs nftables | Läste genomgången |
| 2026-11-05 | Tidssynk | Vad betyder chronyc tracking? | Systemtid, Leap status, omräkning till UTC | Körde kommandona, gjorde quiz, testade loggsök |
| 2026-11-05 | Zonuppdraget, VS Code | Två repon i samma arbetsyta | Multi-root workspace och namnfält | Ändrade konfigurationen själv |
| 2026-11-04 | Utvecklingssamtal | Presentation inför samtalet | Byggde bildspel från teamets repo och pcap | Hittade fel i repot och övade på frågor |
| 2026-11-04 | U5.3 | Logga root-kommandon med auditd | Regler för execve och syslog-plugin | Konfigurerade servern, skrev egen sammanfattning |
| 2026-11-04 | U5.2 | Skillnad mellan två rsyslog-konfigurationer | kern.\* i klartext vs allt över TLS; hittade rätt föreläsning | Jämförde med min konfiguration |
| 2026-11-04 | rsyslog TLS | Varför fastnar curl mot CA-filen? | DNS gav publik IP, brandväggen släppte bara port 514 | Felsökte på servern |
| 2026-11-04 | U5.4 | Förklara en kompis awk-rad | Arrayer i awk, grep/sort/uniq | Löste uppgiften själv med less innan |
| 2026-11-04 | Workshop 1 | Färdigställa loggkällekartan | Tabell och fem frågor utifrån mina loggkällor | Underlaget kom från min server |
| 2026-11-03 | Övningsuppgifter v5 | Vad betyder Storage= och SystemMaxUse=? | journald, rsyslog och logrotate | Ställde följdfrågor |
| 2026-11-03 | journald | Varför försvinner journalen vid omstart? | /run ligger i RAM; imjournal | AI rättade mitt svenska utkast |
| 2026-11-03 | Kursmål 5 | Vad betyder centraliserad loggning och SOC? | SIEM, Wazuh, verifiering med simulerad brute force | Förberedde formativt samtal |
| 2026-11-03 | Loggkällekarta | Sex loggkällor med exempelrader | Rotation, lagringstid, tidsformat | Fyllde i tabellen själv, AI rättade enskilda celler |
| 2026-11-03 | U5.2 | Kö som överlever avbrott och omstart | Disk-kö; felsökte mina testkörningar | Körde testet själv flera gånger |
| 2026-11-03 | RFC 5425 | Syslog över TLS och rsyslog-konfiguration | Hot, certifikat, felsökning av DNS och brandvägg | Konfigurerade och verifierade TLS själv |
| 2026-11-02 | Syslog RFC 5424/3164 | Lär mig föreläsningen | PRI, tidsstämpel, logger | Räknade PRI själv, gjorde quiz |
| 2026-11-02 | Facitfråga | Vad går förlorat med bara lokala loggar? | Jämförde med lärarens facit | Formulerade eget svar |
| 2026-11-02 | Loggläsning | Vad betyder auid? | auid och UID-intervall | Drog slutsatsen själv |
| 2026-11-02 | Vecka 5, Föreläsning 1 | Skillnad på att ha och lita på en logg? | Fyra tillitsvillkor: integritet, rätt tid, rätt avsändare, fullständighet | Skrev svaret själv, AI rättade stavning |
| 2026-11-02 | Zonuppdraget | Hur hämtar jag en fil från servern? | scp via jump-host (-J) | Körde kommandot, analyserade pcap |
| 2026-11-02 | Testmatris | Stämmer pcap mot CSV-filen? | Jämförde rad för rad och rättade CSV | Ska verifiera antagandena |
| 2026-11-02 | nftables | ICMP-begränsning, meta l4proto, tillåtlista | Regelsyntax och explicit drop | Skrev och testade reglerna själv |
| 2026-11-02 | Jump-server | Permission denied via SSH | Ny nyckel och authorized\_keys | Bytte nyckel själv |
| 2026-11-02 | Verktyg | tshark, ncat och git clone i VS Code | Grundläggande användning | Använde dem i labbarna |

AI användes som stöd för förklaringar, felsökning och språkgranskning. Uppgifterna skrevs, kördes och testades av mig i labbmiljön.

## Så använder jag AI

- **Fördjupning av föreläsningar:** de inspelade föreläsningarna går inte tillräckligt djupt, så jag använder AI för en grundligare genomgång av samma material, med kontrollfrågor och quiz.
- **Felsökning:** när något inte fungerar i labbmiljön frågar jag om möjliga orsaker och testar själv på servern.
- **Granskning:** jag skriver egna svar och låter AI granska tekniska detaljer och språk.
