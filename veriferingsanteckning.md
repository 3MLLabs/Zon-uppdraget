# Verifieringsanteckning: elev-42

Server: elev-42 (10.40.7.2), Appzon, team 7
Loggserver: 172.20.1.58:6514 (TLS, log.sec.chas-lab.dev)
Identifierare: spar2fdc2baa

## Testhändelse

| Identifierare | Ungefärlig tid (UTC) | Värdnamn | Källa | Söksträng | Hittad centralt? Avvikelse? |
|---|---|---|---|---|---|
| spar2fdc2baa-verifiering | 2026-11-06 08:25 | elev-42 | systemlogg (logger, tagg sparbarhet, user.notice) | loggsök spar2fdc2baa-verifiering | Ska kontrolleras från elev-42. |
| spar2fdc2baa-auth | 2026-11-06 08:27 | elev-42 | autentiseringslogg (logger, tagg sparbarhet, authpriv.notice) | loggsök spar2fdc2baa-auth | Ska kontrolleras från elev-42. |
| Ingen identifierare | 2026-11-06 08:33 | elev-42 | brandvägg (nftables, prefix nft-drop-out) | loggsök 10.40.7.89 | Ska kontrolleras från elev-42. |

## Skickat (elev-42)

[student@elev-42 ~]$ logger -p user.notice -t sparbarhet "spar2fdc2baa-verifiering"
[student@elev-42 ~]$ logger -p authpriv.notice -t sparbarhet "spar2fdc2baa-auth"

# Kontrollera att auth-raden finns i den lokala loggen:
[student@elev-42 ~]$ sudo grep spar2fdc2baa-auth /var/log/secure

## Mottaget (loggsök på jump)

Följande kommandon används för att kontrollera att loggarna finns på den centrala loggservern:

[elev-42@jump ~]$ loggsök spar2fdc2baa-verifiering
[elev-42@jump ~]$ loggsök spar2fdc2baa-auth
[elev-42@jump ~]$ loggsök 10.40.7.89

## Brandväggstest

Brandväggstestet genomfördes i båda riktningarna tillsammans med teamkamratens server elev-28 (172.20.1.128).

En utgående anslutning från elev-42 till elev-28 på port 8080 testades. Försöket stoppades av brandväggen på elev-42 innan paketet nådde elev-28.

En anslutning från elev-28 till elev-42 på samma port testades också. Det försöket stoppades av brandväggen på elev-28.

Det betyder att båda servrarna stoppade sina egna utgående anslutningar. På elev-42 sparas brandväggshändelsen med prefixet nft-drop-out. Rsyslog skickar sedan loggen vidare till loggservern genom TLS.

För att kontrollera att allt fungerar behöver loggen från elev-42 hittas på den centrala loggservern.

## Jämförelse

| Fält | Skickat | Mottaget | Stämmer? |
|---|---|---|---|
| Meddelande | spar2fdc2baa-verifiering | Ska kontrolleras | Ej verifierat |
| Värdnamn | elev-42 | Ska kontrolleras | Ej verifierat |
| Källadress | 10.40.7.2 | Ska kontrolleras | Ej verifierat |
| Applikation | sparbarhet | Ska kontrolleras | Ej verifierat |
| Kanal | TLS, port 6514 | Ska kontrolleras | Ej verifierat |
| Tid | 08:25:00 UTC | Ska kontrolleras | Ej verifierat |
| Läsbarhet | Ingen uppgift | Ska kontrolleras | Ej verifierat |

Observation: Tiden i loggen visas bara med hela sekunder. Loggservern visar även millisekunder. Därför kan tiderna skilja sig lite.

Observation: Den gamla testhändelsen från U5.1 (spar2fdc2baa) gick inte längre att hitta med loggsök, trots att U5.1 blev godkänd. Det kan bero på att loggsök bara visar loggar från en viss tidsperiod eller att loggarna inte sparas så länge. Se skyddsbeskrivningen, avsnitt 3.4.
