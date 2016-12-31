#!/bin/bash

manager_ip="$1"
manager_name="$2"
worker_ip="$3"
worker_ipv6="$4"
worker_name="$5"
floating_ip="$6"

really=$(echo $worker_ipv6 | tr -d "[]")

docker-machine create --driver generic --generic-ip-address $really --generic-ssh-key=key/id_rsa -generic-ssh-user=ubuntu --engine-opt insecure-registry=${floating_ip}:5000 $worker_name

eval $(docker-machine env $manager_name)
TOKEN=$(docker swarm join-token -q worker)

eval $(docker-machine env $worker_name)
docker swarm join --token $TOKEN ${manager_ip}:2377
