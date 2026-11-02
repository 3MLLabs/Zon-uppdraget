# Tillgångsförteckning

**Gjord av:** Victor · **Datum:** 2026-10-19 

| Namn | Roll | Subnät | Adress | Tjänster |
|---|---|---|---|---|
| webserver | utåtriktad server | 10.40.10.0/24 | 10.40.10.10 | HTTP 80 HTTPS 443 |
| applikationserver | verksamhets logik | 10.40.20.0/24 | 10.40.20.10 | HTTP 80 HTTPS 443 |
| Kunddatabas | Databas för kunduppgifter | 10.40.30.0/24 | 10.40.30.10 | MYSQL | 
| Jump-server | Enda vägen in till det interna nätet | 10.20.40.0/24 | 10.40.40.20 | SSH, MFA |
| Loggserver | centraliserad loggserver | 10.40.40.0/24 | 10.40.40.20 | Syslog |
| Klient datorer | organisationens klientdatorer | 10.40.50.0/24 | 10.40.50.x | HTTPS, DNS, EPOST |



