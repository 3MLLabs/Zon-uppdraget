# Incidentärenden – elev-28

---

## Incident 1

| Fält | Värde |
|---|---|
| **ID** | T-01 |
| **Tid** | Från 2026-11-12 09:24:08.707 till 2026-11-12 09:24:46.708 |
| **Monitor/regel** | 5710 – Fel användarnamn elev-28 |
| **Agent/källa** | elev-28 |

### Observation
- **Käll-IP:** 172.20.1.2
- **Användare:** felnamn
- **Antal händelser och tidsspann:** 12 händelser, 9 försök. Från 2026-11-12 09:24:08.707 till 2026-11-12 09:24:46.708
- **Relevanta loggrader:**

```
2026-11-12T08:24:45.664427+00:00 elev-28 sshd-session: Failed password for invalid user felnamn from 172.20.1.2 port 36762 ssh2
2026-11-12T08:24:34.162973+00:00 elev-28 sshd-session: Invalid user felnamn from 172.20.1.2 port 36762
```

### Slutsats

| | |
|---|---|
| **Vad hände** | Försök att gissa lösenord |
| **Vad berördes** | Servern elev-28 |
| **Bedömning** | Ett skarpt försök att logga in på servern genom att gissa blint på användarnamn och lösenord |
| **Åtgärd** | Blockera IP-adressen |

---

## Incident 2

| Fält | Värde |
|---|---|
| **ID** | T-02 |
| **Tid** | 2026-11-12 10:50:10.079 till 2026-11-12 10:50:12.080 |
| **Monitor/regel** | elev-28 | nft drop OUT >0 |
| **Agent/källa** | elev-28 |

### Observation

- **Käll-IP:** 172.20.1.143
- **Användare:** –
- **Antal händelser och tidsspann:** 2 händelser, från 2026-11-12 10:50:10.079 till 2026-11-12 10:50:12.080
- **Relevanta loggrader:**

```
2026-11-12T09:50:11.550571+00:00 elev-28 kernel: nft-drop-in: IN=eth1 OUT= MAC=86:00:00:26:0f:c4:d2:74:7f:6e:37:e3:08:00 SRC=172.20.1.143 DST=172.20.1.128 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=31942 DF PROTO=TCP SPT=57124 DPT=443 WINDOW=64860 RES=0x00 SYN URGP=0
```

- **Sökning utan värdfilter (fråga + resultat):**

```
location:*elev-28* and full_log:"NFT DROP IN:"
```

### Slutsats

| | |
|---|---|
| **Vad hände** | .143 försökte skicka data över port 443 |
| **Vad berördes** | Min server |
| **Bedömning** | Med bara 2 träffar är det svårt att se vad som hänt |
| **Åtgärd** | Bevaka adressen efter ytterligare försök |

---

## Incident 3

| Fält | Värde |
|---|---|
| **ID** | T-03 |
| **Tid** | Larmet startade 2026-11-12 13:14 CET, till 13:15 CET |
| **Monitor/regel** | elev-28 \| sudo till root (5402) >0, rule.id:5402 |
| **Agent/källa** | elev-28 |

### Observation

- **Käll-IP:** Lokal användare
- **Användare:** student / elev-28
- **Antal händelser och tidsspann:** 1 händelse, 2026-11-12 13:14 till 13:16
- **Relevanta loggrader:**

```
2026-11-12T12:14:09.770106+00:00 elev-28 sudo: student : TTY=pts/2 ; PWD=/home/student ; USER=root ; COMMAND=/bin/nano
```

- **Sökning utan värdfilter (fråga + resultat):**

```
location:*elev-28* and rule.id:5402
```

### Slutsats

| | |
|---|---|
| **Vad hände** | Någon körde `sudo nano` på elev-28 |
| **Vad berördes** | sudo / `sudo nano` |
| **Bedömning** | Legitimt, eftersom student är användaren och bara nano öppnades |
| **Åtgärd** | Ingen, det är legitim aktivitet som har loggats |

---

## Incident 4

| Fält | Värde |
|---|---|
| **ID** | T-04 |
| **Tid** | *‹datum och tid för larmet›* |
| **Monitor/regel** | elev-28 \| nft drop OUT >0 |
| **Agent/källa** | 10.40.7.89 |

### Observation

- **Käll-IP:** 10.40.7.89
- **Användare:** –
- **Antal händelser och tidsspann:** 4
- **Relevanta loggrader:**

```
2026-11-12T12:21:39.068818+00:00 elev-28 kernel: nft-drop-out: IN= OUT=eth2 SRC=10.40.7.89 DST=10.40.7.2 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=60666 DF PROTO=TCP SPT=41798 DPT=31337 WINDOW=64860 RES=0x00 SYN URGP=0
```

- **Sökning utan värdfilter (fråga + resultat):**

```
location:*elev-28* and "NFT DROP OUT"
```

### Slutsats

| | |
|---|---|
| **Vad hände** | Något försökte skicka data ut. Eftersom det var få paket verkar det ha varit någon slags testkörning |
| **Vad berördes** | 10.40.7.89 / 10.40.7.2 |
| **Bedömning** | Legitimt, eftersom trafiken bara gick mot en värd i det lokala nätet. Trafiken blockerades i den utgående kedjan, så inget har lämnat källservern |
| **Åtgärd** | Bevaka efter mer utbredda försök att kontakta servrar |


# Olika Larm – elev-28

---

## 5710/5712 – Fel användarnamn / Brute force

| Fält | Värde |
|---|---|
| **Sökning** | `location:/var/log/remote/elev-28/syslog.log` |
| **Monitorfilter** | `location is /var/log/remote/elev-28/syslog.log` och `rule.id is 5710` |
| **Utlöses när** | Fler än 8 försök |
| **Så utlöser du den** | Triggervillkor: IS ABOVE 8 |
| **Gränsfall som inte ska matcha** | Färre än 8 försök |

---

## Drop IN

| Fält | Värde |
|---|---|
| **Sökning** | `location:/var/log/remote/elev-28/syslog.log` |
| **Monitorfilter** | `location:/var/log/remote/elev-28/syslog.log` och `data.action: nft-drop-in:` |
| **Utlöses när** | Fler än 0 |
| **Så utlöser du den** | 1 drop in eller 1 drop out |
| **Gränsfall som inte ska matcha** | Inga |

---

## SUDO-varning

| Fält | Värde |
|---|---|
| **Sökning** | `location:/var/log/remote/elev-28/syslog.log` |
| **Monitorfilter** | `rule.id 5402` |
| **Utlöses när** | Fler än 0 |
| **Så utlöser du den** | 1 sudo-kommando |
| **Gränsfall som inte ska matcha** | Inga |

---

## Drop OUT

| Fält | Värde |
|---|---|
| **Sökning** | `location:/var/log/remote/elev-28/syslog.log` |
| **Monitorfilter** | `location:/var/log/remote/elev-28/syslog.log` och `data.action is nft-drop-out:` |
| **Utlöses när** | Data som blockeras med nft-drop-out försöker skickas |
| **Så utlöser du den** | Försök skicka data ut från servern |
| **Gränsfall som inte ska matcha** | Inga |


## Playbook

### Larm 1

Larm: elev-28 | sudo till root (5402) >0

Vad larmet betyder: Någon har använt sudo på servern

Förberedelse: Du behöver Wazuh konto, indexet wazuh-archives-*

1. Notera larmet i Alerting > Alerts > elev-28 | sudo till root (5402) >0. Notera tid.
2. Sök efter händelsen i wazuh-archives-* med "location: *elev-28* and rule.id:5402" under den noterade tidsberioden. Notera antal träffar
3. Öppna träffen och notera full_log värdet för att avgöra vad som har försökt köras, notera även data.srcuser
4. Ta beslut om larmet är legitimt, eller misstänkt, beroende på vad som har försökt göras med sudo

Åtgärder

Agera utifrån vilket kommando som försökte köras med sudo, bevaka användaren.

### Larm 2

Larm: elev-28 | nft drop OUT >0

Vad larmet betyder: Data har försökt skickas från servern men droppats av brandväggsregeln, default drop

Förberedelse: Du behöver Wazuh konto, indexet wazuh-archives-*

1. Notera larmet i Alerting > Alerts > elev-28 | nft drop OUT >0. Notera tid.
2. Sök efter händelsen i wazuh-archives-* med "location: *elev-28* and "NFT DROP OUT" under den noterade tidsberioden. Notera antal träffar
3. Öppna träffen och notera full_log värdet för att avgöra vad som har försökt kontaktas, notera även data.dstip
4. Ta beslut om larmet är legitimt, eller misstänkt, beroende på mängden träffar

Åtgärder

Om många försök har gjorts, kicka användaren från servern, verifiera att rätt person har tillgång till kontot. Verifiera inloggningar.

### Larm 3

Larm: elev-28 | nft drop IN >0

Vad larmet betyder: Data har försökt skickas till servern men droppats av brandväggsregeln, default drop

Förberedelse: Du behöver Wazuh konto, indexet wazuh-archives-*

1. Notera larmet i Alerting > Alerts > elev-28 | nft drop IN >0. Notera tid.
2. Sök efter händelsen i wazuh-archives-* med "location: *elev-28* and "NFT DROP IN" under den noterade tidsberioden. Notera antal träffar
3. Öppna träffen och notera full_log värdet för att avgöra vad som har försökt kontaktas, notera även data.srcip
4. Ta beslut om larmet är legitimt, eller misstänkt, beroende på mängden träffar

Åtgärder
Om många försök har gjorts, kicka användaren från servern, verifiera att rätt person har tillgång till kontot. Verifiera inloggningar.

### Larm 4

Larm: elev-28 | SSH ogiltigt användarnamn (5710) >8

Vad larmet betyder: Någon har försökt logga in på ett icke existerande konto över 8 ggr

Förberedelse: Du behöver Wazuh konto, indexet wazuh-archives-*

1. Notera larmet i Alerting > Alerts > elev-28 | SSH ogiltigt användarnamn (5710) >8
2. Sök efter händelsen i wazuh-archives-* med "location: *elev-28* and rule.id:5710 under den noterade tidsberioden. Notera antal träffar
3. Öppna träffen och notera full_log värdet, rule.description, rule.mitre.technique notera även data.srcip
4. Ta beslut om larmet är legitimt, eller misstänkt, beroende på mängden träffar och innehåll i träffarna

Åtgärder

Spara så mycket information som finns i de olika träffarna, och loggför dessa.