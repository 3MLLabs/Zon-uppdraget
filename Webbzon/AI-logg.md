# AI-logg – elev-40 (Martin)

AI: Claude. Kursmål 9.

## Så arbetar jag
- AI förklarar och ger förslag på kommandon.
- Jag kör alla kommandon själv. Sedan kollar jag att det blev rätt.
- Jag kollar med: `nft -c`, `rsyslogd -N1`, tester, loggar och CTF.
- Flaggor och texter skriver jag själv. VG gör jag utan AI.
- Peter har sagt att jag får använda AI, om jag kan förklara vad som görs.

## Logg (från vecka 8)

| Datum | Varför | Vad jag frågade | Vad AI svarade | Stämde det? Hur jag kollade |
|---|---|---|---|---|
| 24/11 | U8.1 | Hur hittar jag data som smugglas ut via DNS? | Leta efter långa DNS-namn. Avkoda dem. | Ja. Jag körde filtret själv och såg de långa namnen. |
| 25/11 | U8.4 | Är trafiken till port 1514 en attack? | Nej, troligen fel inställning. Samma mål och port hela tiden. | Ja. Jag såg bara ett mål och en port, var femte sekund. En attack provar många portar. |
| 26/11 | Workshop 2 | Varför hittar Wazuh inget när jag söker på tiden? | Först fel svar. Sedan: skriv `\:` i stället för `:`. | AI hade fel först. Jag testade `\:` och fick träffar. |
| 26/11 | Workshop 2 | Hur söker jag på port 1514 i Wazuh? | `full_log:*1514*` | Nej. Den hittade 1514 i klockslag. Jag bytte till `data.dstport:1514`. |
| 27/11 | Rätta D4 | Hur gör jag tidsregeln (NTP) snävare? | Kolla vilken tidsserver som används. Tillåt bara den. | Ja. `chronyc -n sources` visade en server. Tiden fungerar efter ändringen. |
| 27/11 | Rätta D7 | Kan uppdateringarna (dnf) låsas till en adress? | Nej, dnf byter server själv. Stäng de interna näten i stället. | Ja. Jag valde det själv. Uppdateringar fungerar. Testet mot loggservern på 443 blev tyst. |
| 27/11 | Rätta F1 | Ska regeln för port 443 in vara kvar? | Ta bort den om inget program använder 443. | Ja. `ss -tlnp` visade inget på 443. Testet från jump blev tyst. |
| 27/11 | Rätta testfallen | Hur rättar jag testfallen? | Byt D5 till 6514. Fyll i vad som faktiskt hände. | Ja. Jag körde testet från elev-40 och jump. 8 av 8 stämde. |
| 27/11 | Förklara reglerna | Hjälp mig förklara reglerna med enkla ord. | En text per regel: vad den gäller, vad den gör, vilket flöde. | Jag läste varje rad mot regelverket. Jag såg att F2 släpper in fler adresser än flödestabellen säger. |

## När AI hade fel eller jag ändrade

| Datum | AI föreslog | Hur jag kollade | Vad jag gjorde |
|---|---|---|---|
| v4 | En gateway per subnät | Föreläsningen: Hetzner använder .1 | Ändrade till .1 |
| 28/10 | Bara ping in | Ping ut fungerade inte (loggen visade stopp) | La till ping ut |
| 29/10 | Kamratens AI-fil | Jämförde med mallen | Använde den inte |
| 2/11 | Port 443 och 80 från alla | Loggen: databasen kom åt webben | Bara internet och klienter. Testat |
| 2/11 | Klienten på .10 | Ping: ingen svarade | Skrev "ej kontrollerad" |
| 2/11 | Testa från egen server | Testet gick inte ut på nätet | Testade från jump |
| 3/11 | F3 till hela appzonen | Flödestabellen: bara .89 | Ändrade till .89 |
| 3/11 | Metod för U5.4 | Kollade själv | Hittade svaret själv |
| 4/11 | Rensa historiken | Historiken är bevis | Behöll den |
| 5/11 | Kommando med `"…"` | Fel i kommandot | Bytte till `'…'` |
| 26/11 | Söka tid utan `\:` | 0 träffar | Bytte till `\:` |
| 26/11 | Söka `*1514*` | Fel träffar | Bytte till `data.dstport:1514` |

## Vad jag har lärt mig
- AI kan ge för öppna regler. Jag jämför med flödestabellen.
- AI kan gissa. Jag kollar alltid på servern.
- Ett test på samma server bevisar inget. Jag testar utifrån.
- 0 träffar bevisar inget. Jag testar sökningen på något jag vet finns.
