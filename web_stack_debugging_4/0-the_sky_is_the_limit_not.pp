# Increase Nginx limits so the web server can handle high concurrent traffic

exec { 'fix--for-nginx':
  command => '
CONF=/etc/nginx/nginx.conf

# Increase worker_connections inside events block
sed -i "s/worker_connections [0-9]\+;/worker_connections 4096;/" $CONF

# Increase file descriptor limit
if ! grep -q "worker_rlimit_nofile" $CONF; then
  sed -i "/worker_processes/a worker_rlimit_nofile 8192;" $CONF
else
  sed -i "s/worker_rlimit_nofile [0-9]\+;/worker_rlimit_nofile 8192;/" $CONF
fi

# Restart nginx
pkill -f nginx || true
/usr/sbin/nginx
',
  path => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
