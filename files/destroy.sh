terraform destroy -force
docker-machine ls -q | xargs docker-machine rm -y
