#!/bin/bash

/home/ubuntu/spark-ec2/copy-dir /etc/ganglia/

# Start gmond everywhere
sudo /etc/init.d/ganglia-monitor restart

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo /etc/init.d/ganglia-monitor restart"
done

# gmeta needs rrds to be owned by nobody
sudo chown -R nobody /var/lib/ganglia/rrds
# cluster-wide aggregates only show up with this. TODO: Fix this cleanly ?
sudo ln -s /usr/share/ganglia/conf/default.json /var/lib/ganglia-web/conf/

sudo /etc/init.d/gmetad restart

# Start http server to serve ganglia
sudo /etc/init.d/apache2 restart
