# Fix "Too many open files" for holberton user by adjusting OS limits

exec { 'change-os-configuration-for-holberton-user':
  command => 'grep -q "^holberton soft nofile" /etc/security/limits.conf || \
echo "holberton soft nofile 4096" >> /etc/security/limits.conf
grep -q "^holberton hard nofile" /etc/security/limits.conf || \
echo "holberton hard nofile 8192" >> /etc/security/limits.conf
grep -q "^session required pam_limits.so" /etc/pam.d/su || \
echo "session required pam_limits.so" >> /etc/pam.d/su
test ! -f /etc/pam.d/su-l || \
(grep -q "^session required pam_limits.so" /etc/pam.d/su-l || \
echo "session required pam_limits.so" >> /etc/pam.d/su-l)
test ! -f /etc/pam.d/common-session || \
(grep -q "pam_limits.so" /etc/pam.d/common-session || \
echo "session required pam_limits.so" >> /etc/pam.d/common-session)',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
