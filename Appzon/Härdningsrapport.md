**Härdningsrapport – elev-28 (utkast)**

**1. Sammanfattning**
Servern kör SELinux i enforcing-läge med targeted-policy, och den egna tjänsten zonvakt körs i en egen domän (`zonvakt_t`) under en laddad policymodul. SSH-konfigurationen har skärpts genom att X11Forwarding stängts av. Root-inloggning med lösenord är blockerad. Lösenordsinloggning för vanliga användare är fortfarande tillåten, och det är den största kvarstående risken i SSH-konfigurationen.

**2. SELinux**
- SELinux är aktiverat (`SELinux status: enabled`) och körs i enforcing (`Current mode: enforcing`).
- Läget i konfigurationsfilen är också enforcing, så läget ligger kvar efter omstart.
- Laddad policy är `targeted`, och MLS-stöd är aktiverat i policyn.
- `deny_unknown` är `allowed`, vilket betyder att klasser och behörigheter som policyn inte känner till tillåts i stället för att nekas.
- Den egna modulen `zonvakt` finns bland de laddade modulerna i `semodule -l`.

**3. Processdomäner**
- zonvakt (PID 1017) körs som `system_u:system_r:zonvakt_t:s0`. Tjänsten är alltså begränsad av sin egen policy och körs inte som `unconfined_service_t`.
- Centrala systemtjänster körs i sina standarddomäner: sshd i `sshd_t`, httpd i `httpd_t`, rsyslogd och systemd-journal i `syslogd_t`, auditd i `auditd_t` och chronyd i `chronyd_t`.
- Ingen systemtjänst i listan körs i en okonfinerad domän.
- Den inloggade användarens session (bash, sshd-session) körs i `unconfined_t`. Det är standard för targeted-policyn och påverkar inte tjänsternas isolering.
- Apache (httpd) körs med fem processer. Tjänsten finns inte med i härdningslistan, så det bör utredas om den behövs.

**4. SSH-konfiguration**

| Inställning | Värde | Källa | Bedömning |
|---|---|---|---|
| X11Forwarding | no | ny drop-in-fil | Åtgärdad. Minskar attackytan eftersom ingen GUI-vidarebefordran behövs. |
| PermitRootLogin | without-password | 10-labb.conf | Root kan inte logga in med lösenord men kan fortfarande logga in med nyckel. |
| PubkeyAuthentication | yes | inbyggt standardvärde | Behövs för nyckelinloggning. |
| PasswordAuthentication | yes | 10-labb.conf | Rekommenderas att sättas till no, eftersom inloggning sker med nyckel. |

- Att lägga ändringen i en egen .conf-fil i stället för att redigera 50-redhat.conf är bättre, eftersom ändringen då inte skrivs över vid paketuppdateringar.
- `sshd -T` visar den faktiska, sammanslagna konfigurationen och är därför rätt kommando för verifiering.
- `without-password` är ett äldre alias för `prohibit-password`.

**5. Verifieringsskript**
Skriptet kontrollerar tre saker: att X11Forwarding är no, att PasswordAuthentication är yes, och att SELinux är i enforcing. Det kontrollerar inte PermitRootLogin och inte att zonvakt körs i `zonvakt_t`. Båda bör läggas till för att skriptet ska täcka hela härdningslistan.

**6. Rekommendationer**
1. Sätt `PasswordAuthentication no` i en drop-in-fil och kör `systemctl reload sshd`.
2. Överväg `PermitRootLogin no` om root-inloggning med nyckel inte behövs.
3. Utred om httpd behövs. Annars stoppar och inaktiverar du tjänsten.
4. Bygg ut verifieringsskriptet med kontroller för PermitRootLogin och zonvakts domän..