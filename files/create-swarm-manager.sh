#!/bin/bash

manager_ip="$1"
manager_ipv6="$2"
manager_name="$3"
floating_ip="$4"

really=$(echo $manager_ipv6 | tr -d "[]")

docker-machine create --driver generic --generic-ip-address $really --generic-ssh-key=key/id_rsa -generic-ssh-user=ubuntu --engine-opt insecure-registry=${floating_ip}:5000 $manager_name

eval $(docker-machine env $manager_name)

docker swarm init --advertise-addr ${manager_ip}:2377
