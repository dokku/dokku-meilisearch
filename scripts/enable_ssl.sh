#!/bin/bash
pushd /var/lib/meillisearchql/data >/dev/null
openssl req -new -newkey rsa:4096 -x509 -nodes -out server.crt -keyout server.key -batch
chmod 600 server.key
sed -i "s/^#ssl = off/ssl = on/" meillisearchql.conf
sed -i "s/^#ssl_ciphers =.*/ssl_ciphers = 'AES256+EECDH:AES256+EDH'/" meillisearchql.conf
popd >/dev/null
