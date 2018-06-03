## Start CONTAINERURL ##
server {
    listen HOSTIP:80;
    server_name CONTAINERURL;
    return 301 https://$host$request_uri;
    #location / { root /var/lib/certs/tmp/CONTAINERPORT/challenge; }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name  CONTAINERURL;

    ssl_certificate /var/lib/certs/CONTAINERURL.crt;
    ssl_certificate_key /var/lib/certs/CONTAINERURL.key;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols  TLSv1.2;

    ssl_ciphers 'ECDH+CHACHA20:ECDHE+AES:!SHA1';
    ssl_prefer_server_ciphers on;
    ssl_dhparam /var/lib/certs/dhparams.pem;
    ssl_ecdh_curve prime256v1:secp384r1:secp521r1;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
    add_header Referrer-Policy "no-referrer" always;
    add_header X-Content-Type-Options "nosniff";
    add_header X-Frame-Options "DENY";
    add_header X-XSS-Protection "1; mode=block";
    add_header Content-Security-Policy "default-src 'self';";

    access_log  /var/log/nginx/log/CONTAINERURL.access.log;
    error_log  /var/log/nginx/log/CONTAINERURL.error.log;
    root   /usr/share/nginx/html;
    index  index.html index.htm;

    client_max_body_size 30M;

    ## send request back to container ##
    location / {
     proxy_pass  http://CONTAINERIP:CONTAINERPORT/SUBDIR;
     proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
     proxy_redirect off;
     proxy_buffering off;
     proxy_set_header        Host            $host;
     proxy_set_header        X-Real-IP       $remote_addr;
     proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header        X-Forwarded-Proto $scheme;
   }
}
## End CONTAINERURL ##
