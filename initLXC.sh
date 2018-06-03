#!/bin/bash

SCRIPTSPATH=`dirname ${BASH_SOURCE[0]}`
source $SCRIPTSPATH/lib.sh
# version,OS,OSRelease=getOSOfContainer
getOSOfContainer /

# create a key pair for ssh into the container as root
if [ ! -f /root/.ssh/id_rsa ]
then
  ssh-keygen -t rsa -C "root@localhost"
fi

# create a new, unique Diffie-Hellman group, to fight the Logjam attack: https://weakdh.org/sysadmin.html
if [ ! -f /var/lib/certs/dhparams.pem ]
then
  mkdir -p /var/lib/certs
  openssl dhparam -out /var/lib/certs/dhparams.pem 4096
fi

# install a cronjob that checks the expiry date of ssl certificates and installs a new letsencrypt certificate
if [ ! -f /etc/cron.d/letsencrypt ]
then
  echo "5 8 * * 6 root PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin cd /usr/share/lxc-scripts && ./letsencrypt.sh all" > /etc/cron.d/letsencrypt
fi

if [ ! -f /usr/bin/lc -a -f /usr/share/lxc-scripts/listcontainers.sh ]
then
  ln -s /usr/share/lxc-scripts/listcontainers.sh /usr/bin/lc
fi

if [[ "$OS" == "Debian" && $OSRelease -ge 8 ]]
then
  systemctl enable cron || exit -1
  systemctl start cron || exit -1
else
  service cron start
  update-rc.d cron defaults
fi
