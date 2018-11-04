#!/bin/bash

topic=""

usage()
{
  echo "usage: createtopic [[[-t topic_name ] | [-h]]"
}

create_topic()
{
  echo -en "Creating topic $topic \n"
  docker run \
      --net=event-store-poc_default \
      --rm confluentinc/cp-kafka:5.0.0 \
      kafka-topics --create --topic $topic --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:2181
}


while [ "$1" != "" ]; do
    case $1 in
        -t | --topic )          shift
                                topic=$1
                                create_topic
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

