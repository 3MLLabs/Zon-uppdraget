# X11 Forwarding

## Åtgärd

Stäng av x11 Forwarding genom att editera /etc/ssh/sshd_config.d/50-redhat.conf och ändra 
X11Forwarding yes till X11Forwarding no. Bättre alternativ är att göra en ny .conf fil med X11Forwarding no. Sen kör sudo systemctl reload sshd för att verkställa.

## Motivation

Jag kör inga program som kräver ett GUI


## Förväntad effekt

Jag kan inte längre köra GUI program via x11 Forwarding


## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '

permitrootlogin without-password /etc/ssh/sshd_config.d/10-labb.conf

pubkeyauthentication yes /Built-in default

passwordauthentication yes /etc/ssh/sshd_config.d/10-labb.conf

x11forwarding no <------ NYA ÄNDRINGEN

## Script?

NEJ

# Root login över SSH

## Åtgärd

Root login. Lämnas som den är (PermitRootLogin prohibit-password i /etc/ssh/sshd_config)

## Motivation

Root-inloggning med lösenord blockeras eftersom root är det mest attackerade kontot. Inloggning med nyckel lämnas kvar som nödväg om min användare blir utelåst och servern inte kan hanteras på annat sätt.

## Förväntad effekt

Ingen kan logga in som root över ssh med lösenord, men med nyckel går det

## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '

permitrootlogin without-password <--------- SAMMA VALUE sätts i /etc/ssh/sshd_config.d/10-labb.conf 

pubkeyauthentication yes <------- Built in default

passwordauthentication yes <------/etc/ssh/sshd_config.d/10-labb.conf

x11forwarding no 

## Script?

NEJ

# pubkeyauthentication över SSH

## Åtgärd

Ingen ändring

## Motivation

Jag behöver kunna logga in och verifiera mig med min pubkey

## Förväntad effekt

Ingen

## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '

permitrootlogin without-password <---------etc/ssh/sshd_config.d/10-labb.conf 

pubkeyauthentication yes <------- Built in default

passwordauthentication yes <------ /etc/ssh/sshd_config.d/10-labb.conf

x11forwarding no 

## Script?

NEJ

# passwordauthentication över SSH

## Åtgärd

Ingen ändring

## Motivation

Jag behöver kunna logga in med lösenord över ssh pga jump servern inte har min privata nyckel

## Förväntad effekt

Ingen

## Hur det verifierades

sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|x11forwarding) '

permitrootlogin without-password <---------/etc/ssh/sshd_config.d/10-labb.conf 

pubkeyauthentication yes <------- Built in default

passwordauthentication yes <------/etc/ssh/sshd_config.d/10-labb.conf

x11forwarding no 

## Script?

NEJ