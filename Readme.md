Changes on this branch
---------------------------------
- Deletions of multiples init* files
- Creation of initService.sh (based on initDebian.sh)
   - Removing architecture configuration
   - Dropping jessie support
   - Use of lvm at container creation
   - Use of fssize at container creation
- Modification of initLXC.sh
   - 4096 dhparam
   - Remove Fedora/CentOS support
- Modification of letsencrypt.sh
   - Stronger configuration
- Modification of nginx.sslconf.tpl
   - 301 (instead of 302) for non https traffic
   - IPv6
   - stronger ciphers list
   - ssl_ecdh_curve
   - multiples header (HSTS, CSP, Referrer-Policy...)
