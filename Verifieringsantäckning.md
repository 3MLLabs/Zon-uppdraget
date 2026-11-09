# Verifieringsanteckning – elev-28

**Server:** elev-28 (10.40.7.89) – Appzon, team 7
**Loggserver:** 172.20.1.58:6514 (TLS, log.sec.chas-lab.dev)
**Identifierare:** sparf2c23235

## Testhändelse

| Identifierare | Ungefärlig tid (UTC) | Värdnamn | Källa | Söksträng | Hittad centralt? Avvikelse? |
|---|---|---|---|---|---|
| sparf2c23235-verifiering | 2026-11-06 08:25 | elev-28 | systemlogg (`logger`, tagg `sparbarhet`, user.notice) | `loggsök sparf2c23235-verifiering` | Ja, mottagen över TLS 08:25:00.912 UTC. Ingen avvikelse i värdnamn, källa eller meddelande. Tidsskillnad under 1 sekund. |
| sparf2c23235-auth | 2026-11-06 08:27 | elev-28 | autentiseringslogg (`logger`, tagg `sparbarhet`, authpriv.notice) | `loggsök sparf2c23235-auth` | Ja, mottagen över TLS 08:27:32.563 UTC. Ingen avvikelse. Tidsskillnad under 1 sekund. loggsök visar inte facility, men raden finns lokalt i /var/log/secure, vilket visar att den klassades som autentiseringslogg (authpriv). |
| – (brandväggsrader kan inte bära text) | 2026-11-06 08:33 | elev-28 | paketfiltret (nftables, prefix `nft-drop-out`) | `loggsök 10.40.7.2` | Ja, mottagen över TLS 08:33:38.722 UTC. Blockerat utgående TCP-anslutningsförsök från 10.40.7.89 till 10.40.7.2:8080. Ingen avvikelse. |

## Skickat (elev-28)

```bash
[student@elev-28 ~]$ logger -p user.notice -t sparbarhet "sparf2c23235-verifiering"
[student@elev-28 ~]$ logger -p authpriv.notice -t sparbarhet "sparf2c23235-auth"

# Kontroll att auth-raden hamnade i autentiseringsloggen lokalt:
[student@elev-28 ~]$ sudo grep sparf2c23235-auth /var/log/secure
Nov  6 08:27:32 elev-28 sparbarhet[101767]: sparf2c23235-auth
```

## Mottaget (loggsök på jump)

```
[elev-28@jump ~]$ loggsök sparf2c23235-verifiering
mottaget 2026-11-06T08:25:00.912Z TLS      | 2026-11-06T08:25:00+00:00 172.20.1.128 elev-28 sparbarhet[101766]: sparf2c23235-verifiering

[elev-28@jump ~]$ loggsök sparf2c23235-auth
mottaget 2026-11-06T08:27:32.563Z TLS      | 2026-11-06T08:27:32+00:00 172.20.1.128 elev-28 sparbarhet[101767]: sparf2c23235-auth

[elev-28@jump ~]$ loggsök 10.40.7.2
mottaget 2026-11-06T08:33:38.722Z TLS      | 2026-11-06T08:33:38+00:00 172.20.1.128 elev-28 kernel: nft-drop-out IN= OUT=eth2 SRC=10.40.7.89 DST=10.40.7.2 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=12300 DF PROTO=TCP SPT=37548 DPT=8080 WINDOW=64860 RES=0x00 SYN URGP=0
```

Brandväggsraden: testet gjordes i båda riktningarna med en teamkamrats server (elev-42, 10.40.7.2) mot port 8080. Försöket från elev-42 stoppades redan i elev-42:s utgående kedja och nådde aldrig elev-28. Mitt försök från elev-28 till 10.40.7.2:8080 stoppades i elev-28:s utgående kedja (`nft-drop-out`, `OUT=eth2`). Kärnan skrev raden, rsyslog skickade den vidare och den kom fram över TLS samma sekund. Det visar att paketfiltrets loggar når loggservern.

## Jämförelse

| Fält | Skickat | Mottaget | Stämmer? |
|---|---|---|---|
| Meddelande | sparf2c23235-verifiering | sparf2c23235-verifiering | Ja |
| Värdnamn | elev-28 | elev-28 | Ja |
| Källadress | 10.40.7.89 | 10.40.7.89 | Ja |
| Applikation | sparbarhet | sparbarhet[101766] | Ja |
| Kanal | TLS, port 6514 | TLS | Ja |
| Tid | 08:25:00 UTC (avsändarens tidsstämpel) | mottaget 08:25:00.912 UTC | Ja, under 1 s skillnad |
| Läsbarhet | – | Hela raden läsbar | Ja |

Observation: avsändarens tidsstämpel har bara hela sekunder (`08:25:00+00:00`), medan loggservern anger mottagningstiden med millisekunder. Avsändarens tid saknar alltså delsekunder.

Observation: den ursprungliga testhändelsen från U5.1 (`sparf2c23235`) gick inte längre att hitta med loggsök, trots att U5.1 godkändes. Det tyder på att loggsök bara söker i en begränsad tidsperiod eller att loggservern inte sparar raderna länge.