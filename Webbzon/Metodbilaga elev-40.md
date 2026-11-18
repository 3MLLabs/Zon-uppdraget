# Metodbilaga – elev-40

Hör till [Härdningsrapport elev-40](Härdningsrapport%20elev-40.md). Workshop 2, vecka 7 (18/11).

**AI-verktyg:** Claude (Anthropic), claude.ai. Utkastet togs fram i en ny chatt som bara fick underlaget nedan. Domarna (stämmer / fel / ogrundat) satte jag mot min egen server med kommandona B1–B18. Jag använde också Claude som stöd i en separat chatt för att planera kommandona och skriva rapporten. Verifieringsskriptet bygger på lärarens referensskript i föreläsning F11, anpassat till min härdningslista med AI-stöd.

## 1. Underlag som matades in
- Min härdningslista (5 rader), samma som i repot.
- `~/underlag.txt` från elev-40, insamlad efter omstart 18/11 med ett kommandoblock:
  `sestatus`, `semodule -l | grep zonvakt`, `ps -eZ | grep zonvakt`, `ls -Z` (zonvakt, logg, /srv/zonwebb), `semanage fcontext -l -C`, utdata från `verifiera-hardning`, `zonvakt.te`, `zonvakt.fc`, `/etc/ssh/sshd_config.d/20-hardning.conf`, `/etc/httpd/conf.d/zonwebb.conf`, `nft list chain inet zon in`.
- **Maskerat:** alla IPv4-adresser byttes automatiskt mot `IP-BORTTAGEN` med `sed -E 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(\/[0-9]+)?/IP-BORTTAGEN/g'`. Kontroll: `grep -c` på IP-adresser i filen gav 0. Strukturen (regelnamn, portar, kommentarer) behölls.

## 2. Prompt (ordagrant)
````
Du ska skriva ett utkast till en härdningsrapport för en Linux-server.
System: Rocky Linux 9, SELinux med targeted policy. Servern heter elev-40 och är webbserver.

Regler:
1. Använd bara underlaget nedan. Hitta inte på filer, kommandon eller inställningar.
2. Skriv rapporten som numrerade påståenden, ett påstående per rad.
3. Ordna påståendena under rubrikerna: SELinux-läge, egen tjänst under egen policy (zonvakt), filkontext för webbinnehåll, paketfilter, SSH, verifieringsskript.
4. För varje åtgärd: vad som gjordes, varför (vilket hot) och hur det verifieras.
5. Markera med [SAKNAS I UNDERLAGET] allt du tror stämmer men inte kan se i underlaget.
6. Skriv på svenska.

Underlag del 1 – min härdningslista:

| Nr | Åtgärd | Motivering (hot) | Förväntad effekt | Hur den verifieras | Skript? | Status |
|---|---|---|---|---|---|---|
| 1 | SELinux enforcing nu och efter omstart | Webbservern är öppen mot internet. Om någon tar över httpd stängs den in, även som root. | Läget är enforcing nu och efter omstart. | `getenforce` → Enforcing · `grep ^SELINUX= /etc/selinux/config` → enforcing | Ja | Genomförd |
| 2 | Bestående fcontext-regel för /srv/zonwebb | httpd får bara läsa webbinnehåll. Regeln finns kvar efter en relabel. | Filerna har typen httpd_sys_content_t. | `sudo semanage fcontext -l -C \| grep zonwebb` | Ja | Genomförd |
| 3 | nftables: policy drop inkommande | Bara flöden i flödestabellen når servern. Allt annat stoppas och loggas. | Kedjan in har policy drop. | `sudo nft list chain inet zon in \| grep "policy drop"` | Ja | Genomförd |
| 4 | SSH: X11Forwarding no och MaxAuthTries 3 | Webbservern kör inga grafiska program. Färre försök gör brute force (T1110) svårare. | `sshd -T` visar x11forwarding no och maxauthtries 3. | `sudo sshd -T \| grep -E '^(x11forwarding\|maxauthtries) '` | Ja | Genomförd |
| 5 | zonvakt i egen domän zonvakt_t, inte permissiv | zonvakt kör som root. Utan egen policy kan den skriva i /etc. | Processen kör i zonvakt_t. overtrad nekas. | `ps -eZ \| grep zonvakt` · `sudo semanage permissive -l \| grep zonvakt` → inget svar | Ja | Genomförd |

Underlag del 2 – utdata från servern (IP-adresser maskerade som IP-BORTTAGEN):

== sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
== semodule -l | grep zonvakt
zonvakt
== ps -eZ | grep zonvakt
system_u:system_r:zonvakt_t:s0      982 ?        00:00:00 zonvakt
== ls -Z
   system_u:object_r:zonvakt_exec_t:s0 /usr/local/bin/zonvakt

/var/log/zonvakt:
system_u:object_r:zonvakt_log_t:s0 zonvakt.log
unconfined_u:object_r:httpd_sys_content_t:s0 /srv/zonwebb
== semanage fcontext -l -C
SELinux fcontext                                   type               Context

/srv/zonwebb(/.*)?                                 all files          system_u:object_r:httpd_sys_content_t:s0
== verifiera-hardning
GÄLLER       SELinux i tvingande läge nu (getenforce = Enforcing)
GÄLLER       SELinux enforcing efter omstart (/etc/selinux/config)
GÄLLER       zonvakt kör i egen domän zonvakt_t
GÄLLER       zonvakt-domänen är inte permissiv
GÄLLER       /srv/zonwebb har bestående fcontext-regel
GÄLLER       paketfiltret: policy drop inkommande
GÄLLER       SSH: X11Forwarding no
GÄLLER       SSH: MaxAuthTries 3
slutkod 0
== zonvakt.te
policy_module(zonvakt, 1.0.0)

########################################
#
# Declarations
#

type zonvakt_t;
type zonvakt_exec_t;
init_daemon_domain(zonvakt_t, zonvakt_exec_t)


type zonvakt_log_t;
logging_log_file(zonvakt_log_t)

########################################
#
# zonvakt local policy
#
allow zonvakt_t self:fifo_file rw_fifo_file_perms;
allow zonvakt_t self:unix_stream_socket create_stream_socket_perms;

manage_dirs_pattern(zonvakt_t, zonvakt_log_t, zonvakt_log_t)
manage_files_pattern(zonvakt_t, zonvakt_log_t, zonvakt_log_t)
manage_lnk_files_pattern(zonvakt_t, zonvakt_log_t, zonvakt_log_t)
logging_log_filetrans(zonvakt_t, zonvakt_log_t, { dir file lnk_file })

domain_use_interactive_fds(zonvakt_t)

files_read_etc_files(zonvakt_t)

miscfiles_read_localization(zonvakt_t)

# Tillagt efter granskning av audit2allow
allow zonvakt_t self:tcp_socket { accept bind create getattr listen read setopt write };
corenet_tcp_bind_generic_node(zonvakt_t)
corenet_tcp_bind_generic_port(zonvakt_t)
corecmd_mmap_bin_files(zonvakt_t)
auth_read_passwd_file(zonvakt_t)
sssd_read_public_files(zonvakt_t)
sssd_search_lib(zonvakt_t)
== zonvakt.fc
/usr/local/bin/zonvakt          --      gen_context(system_u:object_r:zonvakt_exec_t,s0)

/var/log/zonvakt(/.*)?          gen_context(system_u:object_r:zonvakt_log_t,s0)
== /etc/ssh/sshd_config.d/20-hardning.conf
X11Forwarding no
MaxAuthTries 3
== /etc/httpd/conf.d/zonwebb.conf
Alias /zon/ /srv/zonwebb/
<Directory /srv/zonwebb>
    Require all granted
</Directory>
== nft list chain inet zon in
table inet zon {
        chain in {
                type filter hook input priority filter; policy drop;
                ct state established,related accept
                ct state invalid drop
                iif "lo" accept
                ip saddr IP-BORTTAGEN tcp dport 22 accept comment "D1 SSH från jump"
                ip saddr IP-BORTTAGEN tcp dport 22 accept comment "D2 kontroll från ctf"
                ip saddr IP-BORTTAGEN tcp dport 80 accept comment "D9 ctf hämtar webbsida U7.2"
                ip saddr IP-BORTTAGEN tcp dport 7540 accept comment "D10 ctf kontrollerar zonvakt U7.3"
                iifname "eth0" tcp dport 443 accept comment "F1 webb https internet"
                ip saddr IP-BORTTAGEN tcp dport 443 accept comment "F1 webb https klient"
                iifname "eth0" tcp dport 80 accept comment "F2 webb http internet"
                ip saddr IP-BORTTAGEN tcp dport 80 accept comment "F2 webb http klient"
                icmp type echo-request limit rate 5/second burst 5 packets accept comment "D8 ping"
                limit rate 10/minute burst 5 packets log prefix "ZON-IN-DROP " level info
        }
}
````
Följdprompt (svaret slutade efter påstående 65): *"Skriv klart avsnitten SSH och Verifieringsskript i samma dokument, med samma regler."*

## 3. Råsvar (oredigerat)
Svaret kom som ett Claude Docs-dokument, "Härdningsrapport (utkast): elev-40". Avskrivet ordagrant:

### SELinux-läge
1. elev-40 är en webbserver med Rocky Linux 9.
2. Åtgärd: SELinux kör i läget enforcing med policyn targeted.
3. Hot: Webbservern är öppen mot internet.
4. Hot: Om en angripare tar över httpd stänger SELinux in processen, också när den kör som root.
5. Belägg: `sestatus` visar "Current mode: enforcing".
6. Belägg: `sestatus` visar "Mode from config file: enforcing".
7. Belägg: `sestatus` visar "Loaded policy name: targeted".
8. Verifiering: `getenforce` ska ge Enforcing. [SAKNAS I UNDERLAGET: själva utdatan från `getenforce`]
9. Verifiering: `grep ^SELINUX= /etc/selinux/config` ska ge enforcing. [SAKNAS I UNDERLAGET: själva utdatan från `grep`]
10. Verifieringsskriptet visar GÄLLER för läget nu och för läget efter omstart.
11. Ingen startparameter i kärnan stänger av SELinux eller sätter det i läget permissive vid omstart. [SAKNAS I UNDERLAGET]
12. httpd kör i en begränsad SELinux-domän. [SAKNAS I UNDERLAGET: `ps -eZ` för httpd]

### Egen tjänst under egen policy (zonvakt)
13. Åtgärd: Policymodulen zonvakt är laddad.
14. Belägg: `semodule -l | grep zonvakt` ger svaret zonvakt.
15. Åtgärd: Processen zonvakt kör i domänen zonvakt_t.
16. Belägg: `ps -eZ` visar `system_u:system_r:zonvakt_t:s0` för PID 982.
17. Programfilen /usr/local/bin/zonvakt har typen zonvakt_exec_t enligt `ls -Z`.
18. Loggfilen /var/log/zonvakt/zonvakt.log har typen zonvakt_log_t enligt `ls -Z`.
19. Typerna i `ls -Z` stämmer med reglerna i zonvakt.fc.
20. `init_daemon_domain(zonvakt_t, zonvakt_exec_t)` gör att tjänsten startar i domänen zonvakt_t.
21. Hot: zonvakt kör som root. [SAKNAS I UNDERLAGET: `ps -eZ` visar inte vilken användare processen kör som]
22. Hot: Utan egen policy kan en root-process skriva i /etc.
23. Policyn ger zonvakt läsrätt i /etc genom `files_read_etc_files`.
24. zonvakt.te innehåller ingen regel som ger skrivrätt i /etc.
25. Policyn ger zonvakt full hantering bara av filer och kataloger med typen zonvakt_log_t.
26. Policyn låter zonvakt skapa TCP-socketar, binda dem och lyssna på dem.
27. `corenet_tcp_bind_generic_port` låter zonvakt binda alla generiska portar, inte bara en bestämd port.
28. Enligt kommentaren i zonvakt.te lades nätverksreglerna till efter en granskning av audit2allow.
29. zonvakt lyssnar på TCP-port 7540. [SAKNAS I UNDERLAGET: utdata som visar lyssnande portar]
30. Åtgärd: Domänen zonvakt_t är inte permissiv.
31. Verifiering: `sudo semanage permissive -l | grep zonvakt` ska inte ge något svar. [SAKNAS I UNDERLAGET: själva utdatan]
32. Verifieringsskriptet visar GÄLLER för "zonvakt-domänen är inte permissiv".
33. Förväntad effekt: SELinux nekar overtrad. [SAKNAS I UNDERLAGET: vad overtrad är och en AVC-post som visar nekandet]

### Filkontext för webbinnehåll
34. Åtgärd: En bestående fcontext-regel ger `/srv/zonwebb(/.*)?` typen httpd_sys_content_t.
35. Belägg: `semanage fcontext -l -C` visar regeln.
36. Hot: httpd ska bara kunna läsa webbinnehåll, inte skriva i det.
37. Regeln finns kvar efter en relabel, eftersom den ligger i den lokala policyn.
38. Katalogen /srv/zonwebb har typen httpd_sys_content_t enligt `ls -Z`.
39. Filerna i /srv/zonwebb har typen httpd_sys_content_t. [SAKNAS I UNDERLAGET: `ls -Z` för filerna i katalogen]
40. `restorecon` kördes efter att regeln lades till. [SAKNAS I UNDERLAGET]
41. httpd publicerar /srv/zonwebb under sökvägen /zon/ genom `Alias` i /etc/httpd/conf.d/zonwebb.conf.
42. Katalogen har `Require all granted`, alltså får alla klienter läsa den.
43. Verifiering: `sudo semanage fcontext -l -C | grep zonwebb` ska visa regeln.
44. Verifieringsskriptet visar GÄLLER för "/srv/zonwebb har bestående fcontext-regel".

### Paketfilter
45. Åtgärd: Kedjan in i tabellen inet zon har policy drop.
46. Hot: Bara godkända flöden ska nå servern.
47. Belägg: `nft list chain inet zon in` visar "policy drop".
48. Kedjan godkänner trafik med ct state established och related.
49. Kedjan stoppar trafik med ct state invalid.
50. Kedjan godkänner trafik på gränssnittet lo.
51. SSH på TCP-port 22 är öppen bara från två källadresser (D1 och D2).
52. HTTPS på TCP-port 443 är öppen från alla källor på eth0 (F1).
53. HTTP på TCP-port 80 är öppen från alla källor på eth0 (F2).
54. TCP-port 7540 är öppen bara från en källadress (D10).
55. Ping (echo-request) är begränsad till 5 paket per sekund (D8).
56. Stoppad trafik loggas med prefixet "ZON-IN-DROP ".
57. Loggningen är begränsad till 10 poster per minut med burst 5.
58. När trafiken överstiger den gränsen loggas inte alla stoppade paket.
59. Härdningslistan säger att "allt annat loggas", men det stämmer bara upp till loggränsen.
60. Reglerna bygger på en flödestabell med beteckningarna D1, D2, D8, D9, D10, F1 och F2. [SAKNAS I UNDERLAGET: själva flödestabellen]
61. Regeln F2 på eth0 täcker också D9 och F2-klientflödet, om de kommer in på eth0. [SAKNAS I UNDERLAGET: vilka gränssnitt servern har]
62. Regelverket finns kvar efter omstart. [SAKNAS I UNDERLAGET: sparad nftables-konfiguration och tjänstens status]
63. Servern använder inte IPv6. Tabellen är av typen inet, och kedjan har ingen regel som godkänner ICMPv6. [SAKNAS I UNDERLAGET]
64. Verifiering: `sudo nft list chain inet zon in | grep "policy drop"` ska ge en träff.
65. Verifieringsskriptet visar GÄLLER för "paketfiltret: policy drop inkommande".

### SSH
66. Åtgärd 1: Filen /etc/ssh/sshd_config.d/20-hardning.conf innehåller `X11Forwarding no`.
67. Varför: Webbservern kör inga grafiska program, så X11-vidarebefordran behövs inte.
68. Hot: X11-vidarebefordran ökar attackytan utan nytta. [SAKNAS I UNDERLAGET: härdningslistan namnger inget hot för X11]
69. Verifiering: `sudo sshd -T | grep -E '^(x11forwarding|maxauthtries) '` ska visa x11forwarding no.
70. Status för åtgärd 1 är Genomförd enligt härdningslistan.
71. Åtgärd 2: Samma fil innehåller `MaxAuthTries 3`.
72. Varför: Färre inloggningsförsök gör brute force (T1110) svårare.
73. Förväntad effekt: sshd tillåter högst 3 autentiseringsförsök.
74. Verifiering: Samma kommando som i påstående 69 ska visa maxauthtries 3.
75. Status för åtgärd 2 är Genomförd enligt härdningslistan.
76. Belägg: Underlaget visar innehållet i 20-hardning.conf med båda raderna.
77. `sshd -T` visar de värden som faktiskt gäller. [SAKNAS I UNDERLAGET: själva utdatan från `sshd -T`]
78. Ingen annan fil i sshd_config.d sätter andra värden för de två inställningarna. [SAKNAS I UNDERLAGET]
79. sshd laddades om efter ändringen. [SAKNAS I UNDERLAGET]
80. Paketfiltret släpper bara in SSH på TCP-port 22 från två källadresser, D1 och D2 (se påstående 51).
81. Därför når brute force från andra adresser på internet inte sshd.
82. Verifieringsskriptet visar GÄLLER för "SSH: X11Forwarding no".
83. Verifieringsskriptet visar GÄLLER för "SSH: MaxAuthTries 3".

### Verifieringsskript
84. Åtgärd: Skriptet verifiera-hardning kontrollerar alla härdningsåtgärder i ett steg.
85. Belägg: Härdningslistan har Ja i kolumnen "Skript?" för alla 5 åtgärder.
86. Varför: Skriptet visar om en inställning har ändrats eller försvunnit efter genomförandet. [SAKNAS I UNDERLAGET: härdningslistan anger inget syfte eller hot för skriptet]
87. Skriptet kontrollerar 8 punkter.
88. SELinux-läge har 2 punkter: läget nu och läget efter omstart.
89. zonvakt har 2 punkter: egen domän och inte permissiv.
90. Filkontext för webbinnehåll har 1 punkt: bestående fcontext-regel för /srv/zonwebb.
91. Paketfilter har 1 punkt: policy drop inkommande.
92. SSH har 2 punkter: X11Forwarding no och MaxAuthTries 3.
93. Belägg: Alla 8 punkter visar GÄLLER.
94. Belägg: Skriptet avslutar med slutkod 0.
95. Verifiering: Kör verifiera-hardning. Alla rader ska visa GÄLLER och slutkoden ska vara 0.
96. Skriptets sökväg, källkod och hur det startas. [SAKNAS I UNDERLAGET]
97. Skriptet kör samma kommandon som kolumnen "Hur den verifieras". [SAKNAS I UNDERLAGET]
98. Skriptets utdata och slutkod när en kontroll misslyckas. [SAKNAS I UNDERLAGET]
99. Begränsning: Skriptet kontrollerar inte att SELinux nekar overtrad.
100. Begränsning: Skriptet kontrollerar fcontext-regeln, men inte typen på de enskilda filerna i /srv/zonwebb.
101. Begränsning: Skriptet kontrollerar inte att SSH bara är öppen från två källadresser.
102. Begränsning: Skriptet kontrollerar inte att paketfiltret finns kvar efter omstart.
103. Datum och tid för körningen. [SAKNAS I UNDERLAGET]

## 4. Rättelselogg
| Nr | Påstående (kort) | Dom | Kommando som avgjorde | Faktiskt utfall | Feltyp | Ändrat till |
|---|---|---|---|---|---|---|
| 42 | Katalogen har `Require all granted`, alltså får alla klienter läsa den. | ogrundat | `cat /etc/httpd/conf.d/zonwebb.conf` | Förväxlar httpd-regeln med vad som når servern. Paketfiltret släpper bara in vissa källor på port 80. | ogrundat | httpd begränsar inte vilka klienter som får läsa /zon/ (`Require all granted`). Vilka som når port 80 avgörs av paketfiltret (F2, D9). |
| 61 | Regeln F2 på eth0 täcker också D9 och F2-klientflödet, om de kommer in på eth0. | fel | `ip -br addr` | Innan D9 fanns svarade `kontrollera U7.2` "gav inget svar". F2 på eth0 täckte alltså inte ctf. | uppfunnet antagande | F2-regeln gäller bara eth0 (internet). ctf når servern via labbnätet, inte eth0. Därför behövs D9. |
| 63 | Servern använder inte IPv6. Tabellen är av typen inet, och kedjan har ingen regel som godkänner ICMPv6. | ogrundat | `ip -6 addr \| grep inet6` | Slutsatsen byggde på att det saknas en ICMPv6-regel. Det bevisar inte att IPv6 inte används. | ogrundat | Servern har inga IPv6-adresser (`ip -6 addr` tomt). sshd lyssnar ändå på [::]:22. Om IPv6 slås på gäller kedjan in även för IPv6 (inet), med policy drop. |
| 73 | Förväntad effekt: sshd tillåter högst 3 autentiseringsförsök. | ogrundat | `sudo sshd -T \| grep …` | MaxAuthTries gäller per anslutning, inte totalt. En angripare kan ansluta igen. | ogrundat | Förväntad effekt: sshd tillåter högst 3 autentiseringsförsök **per anslutning**. Därefter bryts anslutningen. |
| 78 | Ingen annan fil i sshd_config.d sätter andra värden för de två inställningarna. | fel | `grep … /etc/ssh/sshd_config.d/*.conf` | AI:n antog att ingen annan fil fanns. `grep` visade 50-redhat.conf. | ogrundat (antagande om filer som inte fanns i underlaget) | 50-redhat.conf sätter `X11Forwarding yes`. Min fil 20-hardning.conf läses före den, och första värdet gäller. Därför gäller `no` (`sshd -T`). |
| 59 | Härdningslistan säger att "allt annat loggas" | stämmer (rättelse av min härdningslista) | `sudo nft list chain inet zon in` | `limit rate 10/minute burst 5 packets log` | – | Härdningslistan rad 3: "Allt annat stoppas och loggas (högst 10 poster per minut)." |

Påståenden markerade [SAKNAS I UNDERLAGET] (8, 9, 11, 12, 21, 29, 31, 33, 39, 40, 60, 61, 62, 63, 68, 77, 78, 79, 86, 96, 97, 98, 103) kontrollerades med nya kommandon (B1–B18) och har nu belägg.

## 5. Utelämningslista
| Utelämnat | Varför |
|---|---|
| Flaggor (U7.1–U7.5) och kvittot från U7.2 | Personliga, får inte delas |
| Lösenord, SSH-nycklar, Wazuh-konto | Hemliga |
| Alla IP-adresser (labbnät, teamnät, publik adress) | Inte publika → IP-BORTTAGEN |
| Hela /etc/ssh/sshd_config och kursens 10-labb.conf | Autentiseringskonfiguration – bara min egen fil 20-hardning.conf togs med |
| zonvakt.te.orig, audit.log, journalctl | Behövs inte för utkastet, kan innehålla adresser |

## Vad jag lärde mig
- AI:n var försiktig och markerade 23 påståenden som [SAKNAS I UNDERLAGET]. Alla gick att avgöra med ett kommando på servern.
- De fel som fanns var antaganden: att ingen annan SSH-fil fanns (nr 78), att F2 på eth0 täcker ctf (nr 61) och att IPv6 inte används (nr 63).
- AI:n hittade också ett fel i min egen härdningslista: "allt annat loggas" stämmer bara upp till loggränsen (nr 59).
