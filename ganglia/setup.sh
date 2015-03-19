#!/bin/bash

/root/spark-ec2/copy-dir /etc/ganglia/

# Start gmond everywhere
service ganglia-monitor restart

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS root@$node "service ganglia-monitor restart"
done

# gmeta needs rrds to be owned by nobody
chown -R nobody /var/lib/ganglia/rrds
# cluster-wide aggregates only show up with this. TODO: Fix this cleanly ?
#ln -s /usr/share/ganglia/conf/default.json /var/lib/ganglia/conf/
cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia.conf

service gmetad restart

# Start http server to serve ganglia
service apache2 restart
