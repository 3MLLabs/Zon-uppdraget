## Adressplan

**Uppdragsgivarens adressutrymme:** `10.40.7.0/24`

### Klient
- Subnät: `10.40.7.0/26`
- Gateway: `10.40.7.1`
- Klientdatorer: `10.40.7.10–10.40.7.62`

### Applikationszon
- Subnät: `10.40.7.64/29`
- Gateway: `10.40.7.1`
- Applikationsserver: `10.40.7.66`

### Datazon
- Subnät: `10.40.7.72/29`
- Gateway: `10.40.7.1`
- Kunddatabas: `10.40.7.74`

### Drift- och förvaltningszon
- Subnät: `10.40.7.80/29`
- Gateway: `10.40.7.1`
- Jump-server: `10.40.7.82`
- Loggserver: `10.40.7.83`

### DMZ
- Subnät: `10.40.7.88/29`
- Gateway: `10.40.7.1`
- Webbserver: `10.40.7.90`
