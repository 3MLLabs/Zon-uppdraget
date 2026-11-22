# AI-användning vecka 46 (9–15 november 2026)


AI användes 5 gånger under vecka 46, i momenten U6.5 (egen Wazuh-detektion), Föreläsning 4 (syslog), Zonuppdraget (git), Workshop 2 (playbooks) och Wazuh-larmen T-01–T-04.

## Logg

| Datum | Moment | Min fråga | AI förklarade | Egen insats |
| --- | --- | --- | --- | --- |
| 2026-11-15 | U6.5, egen Wazuh-detektion med ATT&CK-märkning | Hur hittar jag beteendet i loggarna och mappar det till ATT&CK? | Läsa auditd-rader, taktik/teknik-metoden; gav till slut T1071.001 med motivering och stegen för monitorn | Hittade syncagent-beaconen i wazuh-archives, byggde monitorn och klarade U6.5; övade sedan metoden och mappade två egna exempel rätt |
| 2026-11-12 | Vecka 6, Föreläsning 4 | Lär mig RFC 5424 och syslog-fälten | Huvudets fält i ordning, PRI = facility × 8 + severity, HOSTNAME och APP-NAME | Räknade själv övningar på PRI, tidszoner och fältordning |
| 2026-11-12 | Zonuppdraget, git | Varför kan jag inte pusha från VS Code? | Vanliga orsaker: inloggning, saknad upstream, skyddad main, behörighet i repot | Felsöker själv i terminalen med git-kommandon |
| 2026-11-12 | Workshop 2, playbooks | Hur skriver jag en playbook? | Struktur enligt NIST 800-61:s fyra faser, byggd från triageloggen | Skriver playbooken själv utifrån mina egna triageärenden |
| 2026-11-12 | Wazuh-larm och monitorer, T-01–T-04 | Formatera mina ärenden och monitorer i markdown på svenska | Ingen ny förklaring, bara formatering och översättning | Analyserade larmen och skrev observationer och slutsatser själv |

AI användes som stöd för förklaringar, felsökning och språkgranskning; uppgifterna skrevs, kördes och testades själv i labbmiljön.

## Så använder jag AI

- **Fördjupning av föreläsningar:** de inspelade föreläsningarna går inte tillräckligt djupt, så jag använder AI för en grundligare genomgång av samma material, med kontrollfrågor och quiz.
- **Felsökning:** när något inte fungerar i labbmiljön frågar jag om möjliga orsaker och testar själv på servern.
- **Granskning:** jag skriver egna svar och låter AI granska tekniska detaljer och språk.
