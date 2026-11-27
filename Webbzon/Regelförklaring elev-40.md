# Regelförklaring – elev-40 (webbservern, 10.40.7.66)

Här förklarar jag varje regel i `Zon.nft` med enkla ord. Uppdaterad 27/11, efter att jag ändrade D4 och D7 och tog bort F1.
Varje regel har ett id, till exempel D1 eller F2. Id:t finns också i `Verkligt_arbete/Flödestabell.md`.

## Så fungerar brandväggen
- Brandväggen har två listor med regler: **in** (trafik som kommer till servern) och **ut** (trafik som servern skickar).
- Grundregeln är **policy drop**. Det betyder: allt som jag inte uttryckligen har tillåtit stoppas. Det kallas default deny.
- Servern läser reglerna uppifrån och ned. Den första regeln som passar bestämmer vad som händer med paketet.

## Listan in – trafik till servern

**`ct state established,related accept`**
Släpper in svar på samtal som redan är godkända. Om jag har en SSH-session öppen, får alla paket i den sessionen komma in. `related` är trafik som hör till ett godkänt samtal, till exempel ett felmeddelande.
Den står först, eftersom de flesta paket är svar. Då behöver resten av reglerna bara bestämma om **nya** samtal.

**`ct state invalid drop`**
Stoppar paket som inte hör till något känt samtal. Det kan vara trasiga eller förfalskade paket.
Den står tidigt, så att sådana paket aldrig når de regler som släpper in trafik.

**`iif "lo" accept`**
Släpper in trafik där servern pratar med sig själv. `lo` är ett internt nätkort som bara finns inne i servern. `iif` betyder "nätkortet paketet kom in på".
Den trafiken kommer aldrig från nätet, så den är ofarlig.

**D1 – `ip saddr 172.20.1.2 tcp dport 22`**
Släpper in SSH (port 22), men bara från jump (172.20.1.2).
All inloggning ska gå via jump. Ingen annan dator kan logga in direkt.

**D2 – `ip saddr 172.20.1.10 tcp dport 22`**
Släpper in SSH från ctf (172.20.1.10), som är kursens kontrollserver.
ctf loggar in och kontrollerar mina CTF-labbar.

**D9 – `ip saddr 172.20.1.10 tcp dport 80`**
Släpper in webbtrafik (port 80) från ctf.
ctf hämtar min webbsida för att kontrollera uppgift U7.2.

**D10 – `ip saddr 172.20.1.10 tcp dport 7540`**
Släpper in trafik på port 7540 från ctf.
ctf kontrollerar mitt program zonvakt (U7.3). Porten är 7500 plus mitt elevnummer 40.

**F2 – `iifname "eth0" tcp dport 80`**
Släpper in webbtrafik (port 80) som kommer från internet. `eth0` är serverns nätkort mot internet.
Jag använder nätkortet i stället för en adress, eftersom alla adresser på internet ska kunna se webbsidan.

**F2 – `ip saddr 10.40.7.0/26 tcp dport 80`**
Släpper in webbtrafik från klientzonen, alltså adresserna 10.40.7.0 till 10.40.7.63.
Användarna i teamnätet ska kunna öppna webbsidan.

**D8 – `icmp type echo-request limit rate 5/second`**
Släpper in ping, men högst 5 per sekund. Fler än så stoppas.
Ping behövs för felsökning. Gränsen hindrar någon från att dränka servern i ping.

**Loggregeln – `limit rate 10/minute log prefix "ZON-IN-DROP "`**
Den står sist. Allt som når hit har ingen regel släppt in. Regeln skriver en rad i loggen och sedan stoppas paketet.
Den skriver högst 10 rader per minut, så att ingen kan fylla loggen. Ordet `ZON-IN-DROP` gör det lätt att söka: `journalctl -k -g ZON-IN-DROP`.

**F1 (port 443 in) – borttagen 27/11**
Regeln släppte in krypterad webbtrafik på port 443. Men inget program lyssnar på 443 (jag kontrollerade med `ss -tlnp`). Regeln gjorde alltså ingenting, så jag tog bort den.

## Listan ut – trafik från servern

**`policy drop` (grundregeln)**
Servern får bara skicka det jag har tillåtit. Om någon tar över servern, kan den inte skicka data vart som helst.

**`ct state established,related accept`**
Släpper ut svar på samtal som kom in. Utan den här regeln skulle min SSH-session aldrig få svar.

**`oif "lo" accept`**
Samma som i listan in. Servern får prata med sig själv. `oif` betyder "nätkortet paketet går ut på".

**D3 – DNS till 185.12.64.1 och 185.12.64.2, port 53**
Servern får fråga efter namn, till exempel vilken adress `mirrors.rockylinux.org` har. Men bara hos Hetzners två DNS-servrar.
`meta l4proto { tcp, udp }` betyder att både TCP och UDP är tillåtet. DNS använder oftast UDP, men TCP när svaret är stort. `th dport` betyder målporten, och det fungerar för både TCP och UDP.

**D4 – `ip daddr 213.239.239.166 udp dport 123`**
Servern får hämta rätt tid (NTP), men bara från ntp3.hetzner.de.
Rätt tid behövs för att tiderna i loggarna ska gå att lita på. Förut fick servern fråga vilken tidsserver som helst. Jag kontrollerade med `chronyc -n sources` att servern bara använder den här.

**D5 – `ip daddr 172.20.1.58 tcp dport 6514`**
Servern får skicka sina loggar till loggservern på port 6514. Loggarna är krypterade (TLS).
Den gamla porten 514 skickade loggar i klartext. Den används inte längre.

**D6 – `udp sport 68 udp dport 67`**
Servern får förnya sin adress (DHCP).
Utan den här regeln kan servern tappa sin adress efter en tid.

**D7 – `ip daddr != { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport 443`**
Servern får använda krypterad webbtrafik (port 443) ut mot internet, men inte mot interna nät. `!=` betyder "inte". De tre adressområdena är de interna nät som också omfattar teamnätet och kursnätet.
Regeln behövs för `dnf`, som hämtar uppdateringar. dnf väljer själv en server bland många, så det finns ingen fast adress att skriva in. Förut fick servern nå 443 överallt, också hos teamkamraterna.

**F3 – `ip daddr 10.40.7.89 tcp dport 8080`**
Webbservern får prata med app-servern på port 8080.
Det är bara webbservern som behöver nå appen.

**D8 – `ip daddr 10.40.7.0/24 icmp type echo-request`**
Servern får pinga datorer i teamnätet.
Det används för felsökning inom teamet.

**Loggregeln – `limit rate 10/minute log prefix "ZON-UT-DROP "`**
Allt som servern försöker skicka men inte får, skrivs i loggen och stoppas sedan.
Det visar om något på servern försöker nå ett ställe det inte får. Exempel: när jag testade port 443 mot loggservern kom det `ZON-UT-DROP` i loggen.

## Så kontrollerar jag
- `sudo nft -c -f /etc/nftables/zon.nft` kontrollerar att filen är rätt skriven, innan jag laddar den.
- `test.sh` testar om trafiken går igenom eller stoppas. Resultatet finns i `Testprotokoll-2711.md`.
- `journalctl -k -g ZON-` visar allt som brandväggen har stoppat.
