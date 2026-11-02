### Checklista


| Princip | Kontrollfråga | vad som räknas som bevis för ja?  | Vem eller vad i vår miljö kan visa beviset |
|---|---|---|---|
| All data sources and computing services are considered resources | Vilka resurser har vi som behöver skyddas? finns dem i tillgångsförteckning? | tillgångslista med servrar, databaser och applikationer. | Tillgångsförteckning i repo
| All communication is secured regardless of network location. | Är all kommunikation innaför/utanför nätverket säkrad? | Brandväggsregler, TLS-konfiguration och nätverkstester. |Klassificering och zonindelning dokument
| Access is granted on a per-session basis | Är åtkomsten begränsad och token/tids baserad | Åtkomstpolicyer och konfiguration för tokenlivslängd. |anslutnings försök utan token ger ingen åtkomst
| Access determined by dynamic policy | sker inloggning enligt policy. (e.g på dagen, rätt plats, uppdaterad osv) |Inloggningsloggar och regler för villkorad åtkomst.| SIEM
| Monitors and measures the integrity and security posture of all assets. | är alla tillgångar upppdaterade och säkrade enligt modern policy |Patchrapporter och säkerhetskonfigurationer.| Microsoft-intune
| resource authentication and authorization are dynamic and strictly enforced before access | Upprätthålls MFA och andra authentiseringsprotokoll innan tillgång till resurs beviljas |MFA-inställningar och autentiseringsloggar.| ICAM
| collects information about the current state of assets, and uses it to improve its security. | Samlas loggar och information kontinuerligt för förbättring av säkerheten övertid  |Centrala loggar, övervakningslarm och incidentrapporter.| Säkerhets rapporter/loggar
