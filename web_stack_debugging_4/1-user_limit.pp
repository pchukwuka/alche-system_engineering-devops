# Raise holberton open-files limit and ensure pam_limits loads for su/login

exec { 'change-os-configuration-for-holberton-user':
  command => 'printf "holberton soft nofile 4096\nholberton hard nofile 8192\n" > \
/etc/security/limits.d/holberton.conf
for f in /etc/pam.d/su \
/etc/pam.d/su-l \
/etc/pam.d/common-session \
/etc/pam.d/common-session-noninteractive \
/etc/pam.d/system-auth \
/etc/pam.d/password-auth \
/etc/pam.d/sshd \
/etc/pam.d/login; do
  [ -f "$f" ] || continue
  grep -q "pam_limits.so" "$f" && continue
  echo "session required pam_limits.so" >> "$f"
done',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
