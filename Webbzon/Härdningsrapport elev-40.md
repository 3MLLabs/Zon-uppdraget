# Härdningsrapport – elev-40 (webb)

Rocky Linux 9, SELinux targeted. Team 7. Belägg insamlade 18/11 efter omstart. Varje påstående har en dom och ett belägg från elev-40. Utkastet skrevs med AI-stöd – se [Metodbilaga elev-40](Metodbilaga%20elev-40.md).

Dom: **stämmer** = kommandot bekräftar · **fel** = kommandot visar motsatsen · **ogrundat** = belägg saknades eller slutsatsen höll inte. Påståenden med dom fel eller ogrundat är rättade (se rättelseloggen).

## SELinux-läge

| Nr | Påstående (rättat) | Dom | Belägg (kommando → utdata) |
|---|---|---|---|
| 1 | elev-40 är en webbserver med Rocky Linux 9. | stämmer | `cat /proc/cmdline` → kärna 5.14.0-687.54.1.**el9**_8, ingen `selinux=0` eller `enforcing=0` |
| 2 | Åtgärd: SELinux kör i läget enforcing med policyn targeted. | stämmer | `sestatus` → Current mode: enforcing · Mode from config file: enforcing · Loaded policy name: targeted |
| 3 | Hot: Webbservern är öppen mot internet. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 4 | Hot: Om en angripare tar över httpd stänger SELinux in processen, också när den kör som root. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 5 | Belägg: `sestatus` visar "Current mode: enforcing". | stämmer | `sestatus` → Current mode: enforcing · Mode from config file: enforcing · Loaded policy name: targeted |
| 6 | Belägg: `sestatus` visar "Mode from config file: enforcing". | stämmer | `sestatus` → Current mode: enforcing · Mode from config file: enforcing · Loaded policy name: targeted |
| 7 | Belägg: `sestatus` visar "Loaded policy name: targeted". | stämmer | `sestatus` → Current mode: enforcing · Mode from config file: enforcing · Loaded policy name: targeted |
| 8 | Verifiering: `getenforce` ger Enforcing. | stämmer | `getenforce` → Enforcing |
| 9 | Verifiering: `grep ^SELINUX= /etc/selinux/config` ger SELINUX=enforcing. | stämmer | `grep ^SELINUX= /etc/selinux/config` → SELINUX=enforcing |
| 10 | Verifieringsskriptet visar GÄLLER för läget nu och för läget efter omstart. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 11 | Ingen startparameter i kärnan stänger av SELinux eller sätter det i permissive (`/proc/cmdline`). | stämmer | `cat /proc/cmdline` → kärna 5.14.0-687.54.1.**el9**_8, ingen `selinux=0` eller `enforcing=0` |
| 12 | httpd kör i den begränsade domänen httpd_t. | stämmer | `ps -eZ \| grep httpd` → system_u:system_r:httpd_t:s0 |

## Egen tjänst under egen policy (zonvakt)

| Nr | Påstående (rättat) | Dom | Belägg (kommando → utdata) |
|---|---|---|---|
| 13 | Åtgärd: Policymodulen zonvakt är laddad. | stämmer | `semodule -l \| grep zonvakt` → zonvakt |
| 14 | Belägg: `semodule -l \| grep zonvakt` ger svaret zonvakt. | stämmer | `semodule -l \| grep zonvakt` → zonvakt |
| 15 | Åtgärd: Processen zonvakt kör i domänen zonvakt_t. | stämmer | `ps -eZ \| grep zonvakt` → system_u:system_r:zonvakt_t:s0 982 zonvakt |
| 16 | Belägg: `ps -eZ` visar `system_u:system_r:zonvakt_t:s0` för PID 982. | stämmer | `ps -eZ \| grep zonvakt` → system_u:system_r:zonvakt_t:s0 982 zonvakt |
| 17 | Programfilen /usr/local/bin/zonvakt har typen zonvakt_exec_t enligt `ls -Z`. | stämmer | `ls -Z` → zonvakt_exec_t /usr/local/bin/zonvakt · zonvakt_log_t zonvakt.log · httpd_sys_content_t /srv/zonwebb |
| 18 | Loggfilen /var/log/zonvakt/zonvakt.log har typen zonvakt_log_t enligt `ls -Z`. | stämmer | `ls -Z` → zonvakt_exec_t /usr/local/bin/zonvakt · zonvakt_log_t zonvakt.log · httpd_sys_content_t /srv/zonwebb |
| 19 | Typerna i `ls -Z` stämmer med reglerna i zonvakt.fc. | stämmer | `cat ~/policy/zonvakt.fc` (underlag) |
| 20 | `init_daemon_domain(zonvakt_t, zonvakt_exec_t)` gör att tjänsten startar i domänen zonvakt_t. | stämmer | `ps -eZ \| grep zonvakt` → system_u:system_r:zonvakt_t:s0 982 zonvakt |
| 21 | Hot: zonvakt kör som root (`ps -eo user`). | stämmer | `ps -eo user,label,pid,comm \| grep zonvakt` → root  system_u:system_r:zonvakt_t:s0  982 zonvakt |
| 22 | Hot: Utan egen policy kan en root-process skriva i /etc. | stämmer | U7.3 17/11: utan policy → "OBS: skrev till /etc/zonvakt-otillaten", domän unconfined_service_t |
| 23 | Policyn ger zonvakt läsrätt i /etc genom `files_read_etc_files`. | stämmer | `cat ~/policy/zonvakt.te` (underlag) |
| 24 | zonvakt.te innehåller ingen regel som ger skrivrätt i /etc. | stämmer | `cat ~/policy/zonvakt.te` (underlag) |
| 25 | Policyn ger zonvakt full hantering bara av filer och kataloger med typen zonvakt_log_t. | stämmer | `cat ~/policy/zonvakt.te` (underlag) |
| 26 | Policyn låter zonvakt skapa TCP-socketar, binda dem och lyssna på dem. | stämmer | `cat ~/policy/zonvakt.te` (underlag) |
| 27 | `corenet_tcp_bind_generic_port` låter zonvakt binda alla generiska portar, inte bara en bestämd port. | stämmer | `cat ~/policy/zonvakt.te` (underlag) |
| 28 | Enligt kommentaren i zonvakt.te lades nätverksreglerna till efter en granskning av audit2allow. | stämmer | `cat ~/policy/zonvakt.te` (underlag) |
| 29 | zonvakt lyssnar på TCP-port 7540. | stämmer | `sudo ss -tlnp \| grep 7540` → LISTEN …:7540 users:(("zonvakt",pid=982)) |
| 30 | Åtgärd: Domänen zonvakt_t är inte permissiv. | stämmer | `sudo semanage permissive -l \| grep zonvakt` → inget svar |
| 31 | Verifiering: `sudo semanage permissive -l \| grep zonvakt` ger inget svar. | stämmer | `sudo semanage permissive -l \| grep zonvakt` → inget svar |
| 32 | Verifieringsskriptet visar GÄLLER för "zonvakt-domänen är inte permissiv". | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 33 | Effekt: SELinux nekar overtrad (zonvakt försöker skriva i /etc). AVC: write på etc_t, permissive=0. | stämmer | `sudo ausearch -m avc -c zonvakt -ts recent -i` → denied { write } … name=etc … zonvakt_t … etc_t tclass=dir permissive=0 |

## Filkontext för webbinnehåll

| Nr | Påstående (rättat) | Dom | Belägg (kommando → utdata) |
|---|---|---|---|
| 34 | Åtgärd: En bestående fcontext-regel ger `/srv/zonwebb(/.*)?` typen httpd_sys_content_t. | stämmer | `sudo semanage fcontext -l -C` → /srv/zonwebb(/.*)? all files … httpd_sys_content_t |
| 35 | Belägg: `semanage fcontext -l -C` visar regeln. | stämmer | `sudo semanage fcontext -l -C` → /srv/zonwebb(/.*)? all files … httpd_sys_content_t |
| 36 | Hot: httpd ska bara kunna läsa webbinnehåll, inte skriva i det. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 37 | Regeln finns kvar efter en relabel, eftersom den ligger i den lokala policyn. | stämmer | `sudo semanage fcontext -l -C` → /srv/zonwebb(/.*)? all files … httpd_sys_content_t |
| 38 | Katalogen /srv/zonwebb har typen httpd_sys_content_t enligt `ls -Z`. | stämmer | `ls -Z` → zonvakt_exec_t /usr/local/bin/zonvakt · zonvakt_log_t zonvakt.log · httpd_sys_content_t /srv/zonwebb |
| 39 | Filen kvitto.txt i /srv/zonwebb har typen httpd_sys_content_t. | stämmer | `ls -Z /srv/zonwebb` → unconfined_u:object_r:httpd_sys_content_t:s0 kvitto.txt |
| 40 | `restorecon -Rv` kördes efter att regeln lades till (U7.2, 16/11). Nu finns inget kvar att ändra. | stämmer | `sudo restorecon -Rnv /srv/zonwebb` → inget att ändra · U7.2 16/11: `restorecon -Rv` → "Relabeled … var_t to … httpd_sys_content_t" |
| 41 | httpd publicerar /srv/zonwebb under sökvägen /zon/ genom `Alias` i /etc/httpd/conf.d/zonwebb.conf. | stämmer | `cat /etc/httpd/conf.d/zonwebb.conf` → Alias /zon/ /srv/zonwebb/ · Require all granted |
| 42 | httpd begränsar inte vilka klienter som får läsa /zon/ (`Require all granted`). Vilka som når port 80 avgörs av paketfiltret (F2, D9). | ogrundat | `cat /etc/httpd/conf.d/zonwebb.conf` → Alias /zon/ /srv/zonwebb/ · Require all granted |
| 43 | Verifiering: `sudo semanage fcontext -l -C \| grep zonwebb` ska visa regeln. | stämmer | `sudo semanage fcontext -l -C` → /srv/zonwebb(/.*)? all files … httpd_sys_content_t |
| 44 | Verifieringsskriptet visar GÄLLER för "/srv/zonwebb har bestående fcontext-regel". | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |

## Paketfilter

| Nr | Påstående (rättat) | Dom | Belägg (kommando → utdata) |
|---|---|---|---|
| 45 | Åtgärd: Kedjan in i tabellen inet zon har policy drop. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 46 | Hot: Bara godkända flöden ska nå servern. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 47 | Belägg: `nft list chain inet zon in` visar "policy drop". | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 48 | Kedjan godkänner trafik med ct state established och related. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 49 | Kedjan stoppar trafik med ct state invalid. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 50 | Kedjan godkänner trafik på gränssnittet lo. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 51 | SSH på TCP-port 22 är öppen bara från två källadresser (D1 och D2). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 52 | HTTPS på TCP-port 443 är öppen från alla källor på eth0 (F1). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 53 | HTTP på TCP-port 80 är öppen från alla källor på eth0 (F2). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 54 | TCP-port 7540 är öppen bara från en källadress (D10). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 55 | Ping (echo-request) är begränsad till 5 paket per sekund (D8). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 56 | Stoppad trafik loggas med prefixet "ZON-IN-DROP ". | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 57 | Loggningen är begränsad till 10 poster per minut med burst 5. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 58 | När trafiken överstiger den gränsen loggas inte alla stoppade paket. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 59 | Härdningslistan säger "allt annat loggas". Rätt: allt annat stoppas och loggas, högst 10 poster per minut (burst 5). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 60 | Reglerna bygger på teamets flödestabell (D1, D2, D8, D9, D10, F1, F2). | stämmer | Repo `Verkligt_arbete/Flödestabell.md` → D1, D2, D8, D9, D10, F1, F2 finns |
| 61 | F2-regeln gäller bara eth0 (internet). ctf når servern via labbnätet, inte eth0. Därför behövs D9. | fel | `ip -br addr` → lo, eth0, eth1, eth2 · `kontrollera U7.2` 16/11 → "gav inget svar" innan D9 fanns |
| 62 | Regelverket finns kvar efter omstart: nftables är enabled och laddar zon.nft. | stämmer | `systemctl is-enabled nftables` → enabled · `include "/etc/nftables/zon.nft"` · skriptet efter omstart → GÄLLER policy drop |
| 63 | Servern har inga IPv6-adresser (`ip -6 addr` tomt). sshd lyssnar ändå på [::]:22. Om IPv6 slås på gäller kedjan in även för IPv6 (inet), med policy drop. | ogrundat | `ip -6 addr \| grep inet6` → inget svar · `ss -tln` → LISTEN [::]:22 |
| 64 | Verifiering: `sudo nft list chain inet zon in \| grep "policy drop"` ska ge en träff. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 65 | Verifieringsskriptet visar GÄLLER för "paketfiltret: policy drop inkommande". | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |

## SSH

| Nr | Påstående (rättat) | Dom | Belägg (kommando → utdata) |
|---|---|---|---|
| 66 | Åtgärd 1: Filen /etc/ssh/sshd_config.d/20-hardning.conf innehåller `X11Forwarding no`. | stämmer | `sudo cat /etc/ssh/sshd_config.d/20-hardning.conf` → X11Forwarding no · MaxAuthTries 3 |
| 67 | Varför: Webbservern kör inga grafiska program, så X11-vidarebefordran behövs inte. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 68 | Hot: X11-vidarebefordran ökar attackytan utan nytta. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 69 | Verifiering: `sudo sshd -T \| grep -E '^(x11forwarding\|maxauthtries) '` ska visa x11forwarding no. | stämmer | `sudo sshd -T \| grep …` → maxauthtries 3 · x11forwarding no |
| 70 | Status för åtgärd 1 är Genomförd enligt härdningslistan. | stämmer | `sudo sshd -T \| grep …` → maxauthtries 3 · x11forwarding no |
| 71 | Åtgärd 2: Samma fil innehåller `MaxAuthTries 3`. | stämmer | `sudo cat /etc/ssh/sshd_config.d/20-hardning.conf` → X11Forwarding no · MaxAuthTries 3 |
| 72 | Varför: Färre inloggningsförsök gör brute force (T1110) svårare. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 73 | Förväntad effekt: sshd tillåter högst 3 autentiseringsförsök **per anslutning**. Därefter bryts anslutningen. | ogrundat | `sudo sshd -T \| grep …` → maxauthtries 3 · x11forwarding no |
| 74 | Verifiering: Samma kommando som i påstående 69 ska visa maxauthtries 3. | stämmer | `sudo sshd -T \| grep …` → maxauthtries 3 · x11forwarding no |
| 75 | Status för åtgärd 2 är Genomförd enligt härdningslistan. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 76 | Belägg: Underlaget visar innehållet i 20-hardning.conf med båda raderna. | stämmer | `sudo cat /etc/ssh/sshd_config.d/20-hardning.conf` → X11Forwarding no · MaxAuthTries 3 |
| 77 | `sshd -T` visar de värden som faktiskt gäller: maxauthtries 3 och x11forwarding no. | stämmer | `sudo sshd -T \| grep …` → maxauthtries 3 · x11forwarding no |
| 78 | 50-redhat.conf sätter `X11Forwarding yes`. Min fil 20-hardning.conf läses före den, och första värdet gäller. Därför gäller `no` (`sshd -T`). | fel | `grep … /etc/ssh/sshd_config.d/*.conf` → 20-hardning.conf: X11Forwarding no, MaxAuthTries 3 · **50-redhat.conf: X11Forwarding yes** |
| 79 | sshd har startats om efter ändringen (servern startades om 18/11 09:05). | stämmer | `date` → 2026-11-18 09:29 UTC · `uptime -s` → 2026-11-18 09:05:10 |
| 80 | Paketfiltret släpper bara in SSH på TCP-port 22 från två källadresser, D1 och D2 (se påstående 51). | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 81 | Därför når brute force från andra adresser på internet inte sshd. | stämmer | `sudo nft list chain inet zon in` (underlag) |
| 82 | Verifieringsskriptet visar GÄLLER för "SSH: X11Forwarding no". | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 83 | Verifieringsskriptet visar GÄLLER för "SSH: MaxAuthTries 3". | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |

## Verifieringsskript

| Nr | Påstående (rättat) | Dom | Belägg (kommando → utdata) |
|---|---|---|---|
| 84 | Åtgärd: Skriptet verifiera-hardning kontrollerar alla härdningsåtgärder i ett steg. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 85 | Belägg: Härdningslistan har Ja i kolumnen "Skript?" för alla 5 åtgärder. | stämmer | Härdningslistan (repo `Webbzon/Härdningslista elev-40.md`) |
| 86 | Varför: Skriptet visar om en inställning har ändrats eller försvunnit efter genomförandet. | stämmer | Test 18/11: `sudo setenforce 0` → GÄLLER INTE, slutkod 1 → `sudo setenforce 1` |
| 87 | Skriptet kontrollerar 8 punkter. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 88 | SELinux-läge har 2 punkter: läget nu och läget efter omstart. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 89 | zonvakt har 2 punkter: egen domän och inte permissiv. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 90 | Filkontext för webbinnehåll har 1 punkt: bestående fcontext-regel för /srv/zonwebb. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 91 | Paketfilter har 1 punkt: policy drop inkommande. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 92 | SSH har 2 punkter: X11Forwarding no och MaxAuthTries 3. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 93 | Belägg: Alla 8 punkter visar GÄLLER. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 94 | Belägg: Skriptet avslutar med slutkod 0. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 95 | Verifiering: Kör verifiera-hardning. Alla rader ska visa GÄLLER och slutkoden ska vara 0. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 96 | Skriptet ligger i /usr/local/bin/verifiera-hardning (root, 755). Det körs med `sudo /usr/local/bin/verifiera-hardning`. | stämmer | `ls -l /usr/local/bin/verifiera-hardning` → -rwxr-xr-x root 1179 18/11 09:02 |
| 97 | Skriptet kör samma kommandon som kolumnen "Hur den verifieras": getenforce, grep config, semanage fcontext, nft list chain, sshd -T, ps -eZ, semanage permissive. | stämmer | `sudo cat /usr/local/bin/verifiera-hardning` → samma kommandon |
| 98 | När en kontroll misslyckas skriver skriptet GÄLLER INTE och slutkoden blir 1 (testat med `setenforce 0`). | stämmer | Test 18/11: `sudo setenforce 0` → GÄLLER INTE, slutkod 1 → `sudo setenforce 1` |
| 99 | Begränsning: Skriptet kontrollerar inte att SELinux nekar overtrad. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 100 | Begränsning: Skriptet kontrollerar fcontext-regeln, men inte typen på de enskilda filerna i /srv/zonwebb. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 101 | Begränsning: Skriptet kontrollerar inte att SSH bara är öppen från två källadresser. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 102 | Begränsning: Skriptet kontrollerar inte att paketfiltret finns kvar efter omstart. | stämmer | `sudo /usr/local/bin/verifiera-hardning` → 8 × GÄLLER, slutkod 0 (efter omstart 18/11) |
| 103 | Rapportens belägg är insamlade 18/11 09:29 UTC, efter omstart 09:05. | stämmer | `date` → 2026-11-18 09:29 UTC · `uptime -s` → 2026-11-18 09:05:10 |

## Rättelselogg

| Nr | Påstående (kort) | Dom | Kommando som avgjorde | Faktiskt utfall | Feltyp | Ändrat till |
|---|---|---|---|---|---|---|
| 42 | Katalogen har `Require all granted`, alltså får alla klienter läsa den. | ogrundat | `cat /etc/httpd/conf.d/zonwebb.conf` | Förväxlar httpd-regeln med vad som når servern. Paketfiltret släpper bara in vissa källor på port 80. | ogrundat | httpd begränsar inte vilka klienter som får läsa /zon/ (`Require all granted`). Vilka som når port 80 avgörs av paketfiltret (F2, D9). |
| 61 | Regeln F2 på eth0 täcker också D9 och F2-klientflödet, om de kommer in på eth0. | fel | `ip -br addr` | Innan D9 fanns svarade `kontrollera U7.2` "gav inget svar". F2 på eth0 täckte alltså inte ctf. | uppfunnet antagande | F2-regeln gäller bara eth0 (internet). ctf når servern via labbnätet, inte eth0. Därför behövs D9. |
| 63 | Servern använder inte IPv6. Tabellen är av typen inet, och kedjan har ingen regel som godkänner ICMPv6. | ogrundat | `ip -6 addr \| grep inet6` | Slutsatsen byggde på att det saknas en ICMPv6-regel. Det bevisar inte att IPv6 inte används. | ogrundat | Servern har inga IPv6-adresser (`ip -6 addr` tomt). sshd lyssnar ändå på [::]:22. Om IPv6 slås på gäller kedjan in även för IPv6 (inet), med policy drop. |
| 73 | Förväntad effekt: sshd tillåter högst 3 autentiseringsförsök. | ogrundat | `sudo sshd -T \| grep …` | MaxAuthTries gäller per anslutning, inte totalt. En angripare kan ansluta igen. | ogrundat | Förväntad effekt: sshd tillåter högst 3 autentiseringsförsök **per anslutning**. Därefter bryts anslutningen. |
| 78 | Ingen annan fil i sshd_config.d sätter andra värden för de två inställningarna. | fel | `grep … /etc/ssh/sshd_config.d/*.conf` | AI:n antog att ingen annan fil fanns. `grep` visade 50-redhat.conf. | ogrundat (antagande om filer som inte fanns i underlaget) | 50-redhat.conf sätter `X11Forwarding yes`. Min fil 20-hardning.conf läses före den, och första värdet gäller. Därför gäller `no` (`sshd -T`). |
| 59 | Härdningslistan säger att "allt annat loggas" | stämmer (rättelse av min härdningslista) | `sudo nft list chain inet zon in` | `limit rate 10/minute burst 5 packets log` | – | Härdningslistan rad 3: "Allt annat stoppas och loggas (högst 10 poster per minut)." |

Påståenden markerade [SAKNAS I UNDERLAGET] (8, 9, 11, 12, 21, 29, 31, 33, 39, 40, 61, 62, 63, 68, 77, 78, 79, 86, 96, 97, 98, 103) kontrollerades med nya kommandon (B1–B18) och har nu belägg.
