                                         
#!/bin/bash

getenforcestat=$(getenforce)
check_x11() {
if sudo sshd -T | grep -q "x11forwarding no"; then
    printf "Gäller : X-11 Forwarding = No\n" && return 0
elif sudo sshd -T | grep -q "x11forwarding yes"; then
    printf "\nGäller inte : X-11 Forwarding = Yes\n" && return 1
else
return 1
fi
}
check_x11
check_passauthent() {
if sudo sshd -T | grep -q "passwordauthentication no"; then
    printf "Gäller inte: Password Authentication = No\n" && return 1
elif sudo sshd -T | grep -q "passwordauthentication yes"; then
    printf "Gäller: Password Authentication = Yes\n" && return 0
else
return 1
fi
}
check_enforcestat(){
if [ "$getenforcestat" = "Enforcing" ]; then
	printf 'Gäller: Getenforce status = %s\n' "$getenforcestat"
elif [ "$getenforcestat" = "Permissive" ]; then
	printf 'Gäller INTE: Getenforce status = %s\n' "$getenforcestat"
elif [ "$getenforcestat" = "Disabled" ]; then
	printf 'Gäller INTE: Getenforce status = %s\n' "$getenforcestat"
fi
}
check_passauthent
check_enforcestat

