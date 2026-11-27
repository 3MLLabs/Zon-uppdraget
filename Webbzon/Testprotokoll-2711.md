# Testprotokoll – elev-40 (webb, 10.40.7.66) – 27/11

Körs efter regeländringarna D4, D7 och F1 (se Verkligt_arbete/Flödestabell.md, Ändringslogg).

## Så fungerar test.sh
- Läser en testfall-fil, en rad i taget.
- Gör ett anslutningsförsök per rad (`/dev/tcp` med `timeout 3`).
- Tolkar svaret:
  - kod 0 = **öppen** (anslutningen gick igenom)
  - kod 124 = **tyst** (inget svar på 3 s, paketet släpps av drop)
  - annan kod = **avvisad** (RST, porten stängd)
- Skriver förväntat och faktiskt utfall bredvid varandra.

## Körning 1: utgående från elev-40
Kommando: `./test.sh testfall.csv | tee ~/resultat-2711.csv`

| id | Destination | Regel | Förväntat | Faktiskt | Tid | Stämmer |
|---|---|---|---|---|---|---|
| D5-till | 172.20.1.58:6514 | D5 logg TLS | öppen | öppen | 13 ms | Ja |
| D7-nek | 172.20.1.58:443 | D7 stänger interna nät | tyst | tyst | 3005 ms | Ja |
| UT80-nek | 172.20.1.58:80 | default deny ut | tyst | tyst | 3005 ms | Ja |
| D7-till | mirrors.rockylinux.org:443 | D7 dnf | öppen | öppen | 21 ms | Ja |

Resultat: 4 av 4 stämmer.
Tid 3005 ms = timeout 3 s, alltså tyst (drop). Kontroll: `journalctl -k -g ZON-UT-DROP` visar raderna mot 172.20.1.58.

## Körning 2: inkommande via jump
Kommando (på jump): `./test.sh testfall-jump.csv | tee ~/resultat-jump-2711.csv`

| id | Destination | Regel | Förväntat | Faktiskt | Tid | Stämmer |
|---|---|---|---|---|---|---|
| F1-borttagen | 2.28.97.87:443 | F1 borttagen | tyst | tyst | 3002 ms | Ja |
| F1-nek | 172.20.1.140:8080 | default deny in | tyst | tyst | 3002 ms | Ja |
| F2-till | 2.28.97.87:80 | F2 webb http | öppen | öppen | 5 ms | Ja |
| F2-nek | 172.20.1.140:23 | default deny in | tyst | tyst | 3002 ms | Ja |

Sammanfattning från test.sh: 4 testfall, 4 stämmer, 0 avviker.
Före ändringen gav F1-till "avvisad": regeln släppte in 443, men inget lyssnade, så servern svarade med RST. Nu är det tyst, eftersom nftables släpper paketet.

## Körning 3: inkommande från elev-28 (10.40.7.89)
Fil: `testfall-webb.csv`. Körs från elev-28 av teamkamrat (jag loggar inte in på annans server).

| id | Port | Varför tyst | Faktiskt |
|---|---|---|---|
| F1-borttagen | 443 | F1 borttagen 27/11 | väntar |
| F2-nek-app | 80 | 10.40.7.89 ligger utanför 10.40.7.0/26 och kommer in på eth2 | väntar |
| IN8080-nek | 8080 | ingen regel in på 8080 | väntar |
| SSH-nek | 22 | SSH bara från jump (D1) och ctf (D2) | väntar |
