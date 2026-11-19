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

Jag behöver inte kunna logga in som root över SSH för det lämnar en mycket bred attackyta

## Förväntad effekt

Ingen kan logga in som root över ssh

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

Jag behöver kunna logga in och verifiera mig med min pubkey

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