```text
+----------------------------------------------+
| KLIENTZON                                    |
| Subnät: 10.40.50.0/24                        |
| Klientdatorer: 10.40.50.10-10.40.50.254      |
+----------------------------------------------+
          |
          +-- HTTPS (TCP 443) ----------------> Webbserver
          |
          +-- SSH/RDP ------------------------> Jump-server
          |   (endast behöriga administratörer)
          |
          +-- BLOCKERAS ----------------------> Kunddatabas
                                                Applikationsserver


+----------------------------------------------+
| DMZ                                          |
| Subnät: 10.40.10.0/24                        |
| Gateway: 10.40.10.1                          |
| Webbserver: 10.40.10.10                      |
+----------------------------------------------+
          |
          +-- Nödvändig applikationstrafik ---> Applikationsserver
              (endast godkänd port)


+----------------------------------------------+
| APPLIKATIONSZON                              |
| Subnät: 10.40.20.0/24                        |
| Gateway: 10.40.20.1                          |
| Applikationsserver: 10.40.20.10              |
+----------------------------------------------+
          |
          +-- Databasanslutning --------------> Kunddatabas
              (endast nödvändig databasport)


+----------------------------------------------+
| DATAZON                                      |
| Subnät: 10.40.30.0/24                        |
| Gateway: 10.40.30.1                          |
| Kunddatabas: 10.40.30.10                     |
+----------------------------------------------+
          ^
          |
          +-- Tillåten anslutning endast från
              applikationsservern


+----------------------------------------------+
| DRIFT- OCH FÖRVALTNINGSZON                   |
| Subnät: 10.40.40.0/24                        |
| Gateway: 10.40.40.1                          |
| Jump-server: 10.40.40.10                     |
| Loggserver: 10.40.40.20                      |
+----------------------------------------------+
          |
          +-- SSH/RDP ------------------------> Hanterade servrar
          |   (endast nödvändiga portar)
          |
          +-- Loggning -----------------------> Loggserver
```