#!/usr/bin/env bash

# Set Spark's memory per machine -- you might want to increase this
export SHARK_MASTER_MEM=1g

# Java options
SPARK_JAVA_OPTS+="-Dspark.kryoserializer.buffer.mb=10 "
#SPARK_JAVA_OPTS+="-verbose:gc -XX:-PrintGCDetails -XX:+PrintGCTimeStamps "
export SPARK_JAVA_OPTS

if [ -f "/home/ubuntu/hive-0.9-bin" ]; then
  # Point HIVE_HOME to the Hive 0.9 binary manually fetched
  # during instance setup. This only applies for Shark v0.8.
  export HIVE_HOME="/home/ubuntu/hive-0.9.0-bin"
fi

export HADOOP_HOME=/home/ubuntu/ephemeral-hdfs
export HIVE_CONF_DIR=/home/ubuntu/ephemeral-hdfs/conf

export MASTER=`cat /home/ubuntu/spark-ec2/cluster-url`
export SPARK_HOME=/home/ubuntu/spark

export TACHYON_MASTER="tachyon://{{active_master}}:19998"
export TACHYON_WAREHOUSE_PATH="/sharktables"

source $SPARK_HOME/conf/spark-env.sh
