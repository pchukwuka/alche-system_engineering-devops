# Fix Nginx/Apache limits so the stack can handle high concurrency

exec { 'fix--for-nginx':
  command => @("BASH")
    set -e

    NGINX_CONF="/etc/nginx/nginx.conf"
    APACHE_CONF="/etc/apache2/mods-enabled/mpm_prefork.conf"

    # Nginx: raise worker_connections (any value) and file limit
    if [ -f "$NGINX_CONF" ]; then
      sed -i 's/worker_connections[[:space:]]*[0-9]\\+;/worker_connections 4096;/' "$NGINX_CONF"

      if grep -q 'worker_rlimit_nofile' "$NGINX_CONF"; then
        sed -i 's/worker_rlimit_nofile[[:space:]]*[0-9]\\+;/worker_rlimit_nofile 8192;/' "$NGINX_CONF"
      else
        sed -i '/worker_processes/a worker_rlimit_nofile 8192;' "$NGINX_CONF"
      fi
    fi

    # Apache: raise prefork limits so it can serve many requests at once
    if [ -f "$APACHE_CONF" ]; then
      sed -i 's/^\\s*ServerLimit\\s\\+[0-9]\\+/ServerLimit          256/' "$APACHE_CONF" || true
      sed -i 's/^\\s*MaxRequestWorkers\\s\\+[0-9]\\+/MaxRequestWorkers   256/' "$APACHE_CONF" || true
      sed -i 's/^\\s*MaxClients\\s\\+[0-9]\\+/MaxClients          256/' "$APACHE_CONF" || true
    fi

    # Restart services (no systemctl)
    if [ -x /etc/init.d/apache2 ]; then
      /etc/init.d/apache2 restart
    fi

    if [ -x /etc/init.d/nginx ]; then
      /etc/init.d/nginx restart
    else
      pkill -f nginx || true
      /usr/sbin/nginx
    fi
    BASH
  path    => ["/bin", "/usr/bin", "/sbin", "/usr/sbin"],
}
