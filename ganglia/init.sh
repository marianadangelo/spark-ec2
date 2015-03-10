#!/bin/bash

# Install ganglia
# TODO: Remove this once the AMI has ganglia by default

#GANGLIA_PACKAGES="ganglia ganglia-web ganglia-gmond ganglia-gmetad"
GANGLIA_PACKAGES="ganglia-monitor ganglia-webfrontend gmetad"

sudo apt-get install -q -y $GANGLIA_PACKAGES

# NOTE: Remove all rrds which might be around from an earlier run
sudo sh -c 'rm -rf /var/lib/ganglia/rrds'
sudo sh -c 'rm -rf /mnt/ganglia/rrds'

# Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
sudo sh -c 'mkdir -p /mnt/ganglia/rrds'
sudo sh -c 'chown -R nobody:nogroup /mnt/ganglia/rrds'
sudo sh -c 'ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds'


for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo apt-get install -q -y ganglia-monitor" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo sh -c 'rm -rf /var/lib/ganglia/rrds'" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo sh -c 'rm -rf /mnt/ganglia/rrds'" & sleep 0.3

  # Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo sh -c 'mkdir -p /mnt/ganglia/rrds'" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo sh -c 'chown -R nobody:nogroup /mnt/ganglia/rrds'" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo sh -c 'ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds'" & sleep 0.3
done
wait
