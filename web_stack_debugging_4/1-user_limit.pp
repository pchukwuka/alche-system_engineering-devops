# Raise open files limit so holberton can log in and read files without errors

exec { 'change-os-configuration-for-holberton-user':
  command => 'grep -q "^\\* soft nofile" /etc/security/limits.conf || echo "* soft nofile 4096" >> /etc/security/limits.conf
grep -q "^\\* hard nofile" /etc/security/limits.conf || echo "* hard nofile 8192" >> /etc/security/limits.conf
grep -q "^session required pam_limits.so" /etc/pam.d/su || echo "session required pam_limits.so" >> /etc/pam.d/su',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
