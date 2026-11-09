# AI-logg – elev-40 (Martin)

AI: Claude. Kursmål 9.

## Så arbetar jag
- AI förklarar och föreslår kommandon.
- Jag kör varje kommando själv och kontrollerar resultatet: `nft -c`, `rsyslogd -N1`, test med trafik, loggar och CTF.
- Flaggor och beskrivningar skriver jag själv. VG gör jag utan AI.

## Fall där AI hade fel eller jag ändrade

| Datum | AI föreslog | Jag kontrollerade | Resultat |
|---|---|---|---|
| v4 | En gateway per subnät | Föreläsning: Hetzner använder .1 | Rättat till .1 |
| 28/10 | Bara ping in (D8) | Pingen ut svarade inte (`ZON-UT-DROP`) | Lade till D8 ut |
| 29/10 | Kamratens AI-fil (`inet filter`, D9, fel sökväg) | Jämförde med mallen och Rocky 9 | Avvisat |
| 2/11 | F1/F2 från alla | Loggen: databasen nådde 443/80 | Bara internet och klient. Testat |
| 2/11 | Klienten på .10 | Ping: ingen svarade | "Ej verifierad" |
| 2/11 | Testa från egen server | Testet gick via `lo` | Testade från jump |
| 3/11 | F3 till hela appzonen | Flödestabellen: bara .89 | Ändrat till .89 |
| 3/11 | Metod för U5.4 | Kontrollerade auid själv | Hittade orden själv |
| 4/11 | `history -c` | Historiken är belägg | Rensar bara minnet. Behöll historiken |
| 5/11 | nft-kommando med `"…"` | `syntax error` | Hela regeln inom `'…'` |

## Vad jag lärt mig
- AI kan ge för breda regler. Jag jämför med flödestabellen.
- AI kan gissa värden. Jag kontrollerar på servern.
- Ett test via `lo` bevisar inget.
