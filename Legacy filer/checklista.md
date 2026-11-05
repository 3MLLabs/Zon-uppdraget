# Checklista - Milstolpe v01

## Person 1 - Tillgångsinventering

### Servrar och tjänster
- [ ] Identifiera alla kända servrar i miljön
- [ ] Dokumentera hostname
- [ ] Dokumentera IP-adresser
- [ ] Dokumentera serverroller
- [ ] Identifiera öppna portar
- [ ] Identifiera körande tjänster

### Belägg
- [ ] Samla utdata från `ss -tulpn`
- [ ] Samla utdata från `ip addr`
- [ ] Samla eventuella `nmap`-resultat
- [ ] Dokumentera hur varje uppgift verifierades

### Leverans
- [ ] Fyll i tillgångstabellen
- [ ] Lägg dokumentationen i repot
- [ ] Skapa Pull Request

---

## Person 2 - Trafikanalys

### Trafikfångster
- [ ] Öppna och analysera fångstfil(er)
- [ ] Identifiera återkommande flöden
- [ ] Identifiera klient → server-trafik
- [ ] Identifiera server → server-trafik

### Dokumentera flöden
- [ ] Källa
- [ ] Mål
- [ ] Protokoll
- [ ] Port
- [ ] Riktning
- [ ] Funktion
- [ ] Frekvens

### Belägg
- [ ] Dokumentera använda tshark-kommandon
- [ ] Dokumentera fångstfil
- [ ] Dokumentera tidpunkt

### Leverans
- [ ] Uppdatera trafikbaslinjen
- [ ] Lägg dokumentationen i repot
- [ ] Skapa Pull Request

---

## Person 3 - TCP/IP-analys

### Protokollanalys
- [ ] Lista alla identifierade protokoll
- [ ] Identifiera transportprotokoll
- [ ] Identifiera applikationsprotokoll
- [ ] Identifiera internetlagerprotokoll
- [ ] Identifiera nätverksåtkomstprotokoll

### Dokumentation
- [ ] Koppla varje flöde till rätt TCP/IP-lager
- [ ] Beskriv varför flödet används
- [ ] Beskriv hur lagren samverkar

### Leverans
- [ ] Skapa sektionen "TCP/IP-analys"
- [ ] Lägg dokumentationen i repot
- [ ] Skapa Pull Request

---

## Person 4 - Dokumentation och kvalitetsgranskning

### Repo
- [ ] Kontrollera mappstruktur
- [ ] Kontrollera README
- [ ] Kontrollera att alla dokument finns

### Granskning
- [ ] Kontrollera att alla tabeller är ifyllda
- [ ] Kontrollera att varje påstående har belägg
- [ ] Kontrollera att alla uppgifter följer kraven
- [ ] Granska Pull Requests

### Checkpoint-kontroll

- [ ] Tillgångsförteckning klar
- [ ] Trafikbaslinje klar
- [ ] TCP/IP-koppling beskriven
- [ ] Belägg bifogade
- [ ] Allt ligger i main-branchen
- [ ] Materialet går att visa på checkpointen

### Leverans
- [ ] Godkänn sammanslagning till main
- [ ] Märk milstolpen som klar på projektbrädan

---

# Gemensam Definition of Done

En uppgift är klar när:

- [ ] Dokumentation finns i repot
- [ ] Belägg finns dokumenterade
- [ ] Commit utförd med eget konto
- [ ] Pushad till egen branch
- [ ] Pull Request skapad
- [ ] Granskad av teamkamrat
- [ ] Merge till main genomförd
