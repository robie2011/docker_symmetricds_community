#!/bin/sh
apk add --no-cache mysql-client

if [ ! "$(ls -A /data/symmetric-server*.zip)" ]; then
    echo "no symmetric-server*.zip file provided for setup. Downloading latest version from sourceforge.net ... (approx. 80MB)"
    apk add --update-cache curl
    cd /data
    curl -O -J -L https://sourceforge.net/projects/symmetricds/files/latest/download?source=filesurl
fi

mkdir -p /opt/symmetric-ds
unzip /data/symmetric-server*.zip -d /opt/symmetric-ds > /dev/null
ln -s /opt/symmetric-ds/symmetric* /opt/symmetric-ds/current