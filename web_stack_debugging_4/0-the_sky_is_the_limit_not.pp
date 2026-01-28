# Fix Nginx configuration to handle high concurrent traffic

exec { 'fix-nginx':
  command => 'sed -i "s/worker_connections.*/worker_connections 4096;/" /etc/nginx/nginx.conf && \
sed -i "/worker_processes/a worker_rlimit_nofile 8192;" /etc/nginx/nginx.conf && \
pkill nginx && nginx',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
