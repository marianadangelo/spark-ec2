#!/bin/bash

# NOTE: Remove all rrds which might be around from an earlier run
sudo rm -rf /var/lib/ganglia/rrds/*
sudo rm -rf /mnt/ganglia/rrds/*

# Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
sudo rm -rf /var/lib/ganglia/rrds

# Make sure rrd storage directory has right permissions
sudo mkdir -p /mnt/ganglia/rrds
sudo chown -R nobody:nogroup /mnt/ganglia/rrds
sudo ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds

# Install ganglia
# TODO: Remove this once the AMI has ganglia by default

#GANGLIA_PACKAGES="ganglia ganglia-web ganglia-gmond ganglia-gmetad"
GANGLIA_PACKAGES="ganglia-monitor ganglia-webfrontend gmetad"

#if ! rpm --quiet -q $GANGLIA_PACKAGES; then
#  yum install -q -y $GANGLIA_PACKAGES;
#fi
sudo apt-get install -q -y $GANGLIA_PACKAGES
for node in $SLAVES $OTHER_MASTERS; do
  #ssh -t -t $SSH_OPTS root@$node "if ! rpm --quiet -q $GANGLIA_PACKAGES; then yum install -q -y $GANGLIA_PACKAGES; fi" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo apt-get install -q -y $GANGLIA_PACKAGES" & sleep 0.3
  # NOTE: Remove all rrds which might be around from an earlier run
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo rm -rf /var/lib/ganglia/rrds/*" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo rm -rf /mnt/ganglia/rrds/*" & sleep 0.3

  # Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo rm -rf /var/lib/ganglia/rrds" & sleep 0.3

  # Make sure rrd storage directory has right permissions
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo mkdir -p /mnt/ganglia/rrds" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo chown -R nobody:nogroup /mnt/ganglia/rrds" & sleep 0.3
  ssh -t -t $SSH_OPTS ubuntu@$node "sudo ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds" & sleep 0.3
done
wait
