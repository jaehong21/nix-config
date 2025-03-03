defaults
    mode tcp
    option tcplog
    option dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

listen stats
    mode http
    bind *:9000
    stats enable
    stats hide-version
    stats refresh 5s
    stats show-node
    stats uri /

frontend http-frontend
    bind *:80
    default_backend http-backend

backend http-backend
    option tcp-check
    balance roundrobin
    server ${primaryServer} ${primaryServer}:30080 check
    server ${backupServer} ${backupServer}:30080 check backup

frontend https-frontend
    bind *:443
    default_backend https-backend

backend https-backend
    option tcp-check
    balance roundrobin
    server ${primaryServer} ${primaryServer}:30443 check
    server ${backupServer} ${backupServer}:30443 check backup 