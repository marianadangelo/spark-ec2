#!/bin/bash

/home/ubuntu/spark-ec2/copy-dir /etc/ganglia/

# Start gmond everywhere
sudo service ganglia-monitor restart

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo chown -R nobody:nogroup /mnt/ganglia/rrds"
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo /etc/init.d/ganglia-monitor restart"
done

sudo chown -R nobody:nogroup /mnt/ganglia/rrds

sudo service gmetad restart

# Start http server to serve ganglia
sudo service apache2 restart
