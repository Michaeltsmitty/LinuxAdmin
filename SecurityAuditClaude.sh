#!/usr/bin/env bash
# SecurityAuditClaude.sh — Ubuntu & CentOS | Run with: sudo bash SecurityAuditClaude.sh

. /etc/os-release # load distro info into variables like $ID and $NAME
case "$ID" in
  ubuntu|debian) FAMILY="ubuntu" ;; # set family for apt-based systems
  centos|rhel|fedora|rocky) FAMILY="centos" ;; # set family for rpm-based systems
  *) FAMILY="unknown" ;;
esac

[[ $EUID -ne 0 ]] && echo "Run as root (sudo)" && exit 1 # exit if not running as root

echo "=============================="
echo " SECURITY AUDIT — $(hostname)" # print the server hostname
echo " OS: $NAME $VERSION_ID" # print distro name and version
echo " Date: $(date)" # print current date and time
echo "=============================="

echo ""
echo "==> 1. FAILED LOGIN ATTEMPTS"
FAILS=$(journalctl -q --no-pager 2>/dev/null | grep -c "Failed password" || grep -c "Failed password" /var/log/auth.log /var/log/secure 2>/dev/null) # count total failed SSH logins
echo "Failed logins: $FAILS" # print the count as a single summary line
systemctl is-active fail2ban 2>/dev/null || echo "fail2ban: not running" # check if fail2ban (auto IP-banning service) is active
grep "^PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null || echo "PermitRootLogin: not set" # check if SSH allows direct root login

echo ""
echo "==> 2. OPEN PORTS & LISTENING SERVICES"
ss -tulnp | awk 'NR>1 {print $1, $5, $7}' # list protocol, address:port, and process — one line per port

echo ""
echo "==> 3. FIREWALL STATUS"
if [[ "$FAMILY" == "ubuntu" ]]; then
  ufw status verbose 2>/dev/null || echo "ufw: not installed" # show ufw firewall status and rules on Ubuntu
else
  systemctl is-active firewalld 2>/dev/null || echo "firewalld: not running" # check if firewalld is running on CentOS
  firewall-cmd --list-all 2>/dev/null || echo "firewall-cmd: not available" # show active firewall zone rules on CentOS
fi

echo ""
echo "==> 4. USER ACCOUNT AUDIT"
awk -F: '$3==0 {print "UID-0: "$1}' /etc/passwd # find accounts with UID 0 (root-level) — should only be root
awk -F: '$2=="" {print "No password: "$1}' /etc/shadow 2>/dev/null # find accounts with no password set
awk -F: '$3>=1000 && $7 !~ /nologin|false/ {print "User: "$1, $7}' /etc/passwd # list human accounts with an interactive login shell
[[ "$FAMILY" == "ubuntu" ]] && getent group sudo || getent group wheel # show members of the privileged sudo or wheel group

echo ""
echo "==> 5. FILE PERMISSION CHECKS"
COUNT=$(find /etc /usr /bin /sbin -type f -perm -o+w 2>/dev/null | wc -l) # count world-writable files (potential tampering risk)
echo "World-writable files found: $COUNT" # print count instead of listing every file
find / -xdev -type f -perm /4000 2>/dev/null # find SUID binaries that run as root even when launched by normal users

echo ""
echo "==> 6. SYSTEM UPDATES & PATCH STATUS"
if [[ "$FAMILY" == "ubuntu" ]]; then
  apt-get update -qq 2>/dev/null # refresh the package list silently on Ubuntu
  COUNT=$(apt list --upgradable 2>/dev/null | grep -vc "Listing") # count available updates without listing them
  echo "Packages with updates available: $COUNT" # print a single summary line
else
  COUNT=$(dnf check-update -q 2>/dev/null | grep -vc "^$" || yum check-update -q 2>/dev/null | grep -vc "^$") # count available updates on CentOS
  echo "Packages with updates available: $COUNT" # print a single summary line
fi
[[ -f /var/run/reboot-required ]] && echo "REBOOT REQUIRED" || echo "No reboot needed" # check if a reboot is needed after kernel or library updates

echo ""
echo "==> AUDIT COMPLETE"
