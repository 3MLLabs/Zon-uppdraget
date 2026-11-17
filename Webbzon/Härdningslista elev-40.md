# Härdningslista – elev-40 (webb, 10.40.7.66)

| Nr | Åtgärd | Motivering (hot) | Förväntad effekt | Hur den verifieras | Skript? | Status |
|---|---|---|---|---|---|---|
| 1 | SELinux enforcing nu och efter omstart | Webbservern är öppen mot internet. Om någon tar över httpd stängs den in, även som root. | Läget är enforcing nu och efter omstart. | `getenforce` → Enforcing · `grep ^SELINUX= /etc/selinux/config` → enforcing | Ja | Genomförd |
| 2 | Bestående fcontext-regel för /srv/zonwebb | httpd får bara läsa webbinnehåll. Regeln finns kvar efter en relabel. | Filerna har typen httpd_sys_content_t. | `sudo semanage fcontext -l -C \| grep zonwebb` | Ja | Genomförd |
| 3 | nftables: policy drop inkommande | Bara flöden i flödestabellen når servern. Allt annat stoppas och loggas. | Kedjan in har policy drop. | `sudo nft list chain inet zon in \| grep "policy drop"` | Ja | Genomförd |
| 4 | SSH: X11Forwarding no och MaxAuthTries 3 | Webbservern kör inga grafiska program. Färre försök gör brute force (T1110) svårare. | `sshd -T` visar x11forwarding no och maxauthtries 3. | `sudo sshd -T \| grep -E '^(x11forwarding\|maxauthtries) '` | Ja | Genomförd |
| 5 | zonvakt i egen domän zonvakt_t, inte permissiv | zonvakt kör som root. Utan egen policy kan den skriva i /etc. | Processen kör i zonvakt_t. overtrad nekas. | `ps -eZ \| grep zonvakt` · `sudo semanage permissive -l \| grep zonvakt` → inget svar | Ja | Genomförd |

Ändras inte: PermitRootLogin (ctf loggar in som root med nyckel) och PasswordAuthentication (inloggning med lösenord från jump).
