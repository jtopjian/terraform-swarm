# Docker Swarm Demo

This repo contains helper scripts to set up RAC infrastructure for the hands-on [Orchestration Lab](http://jpetazzo.github.io/orchestration-workshop).

## Prerequisites

* Make sure you have IPv6 connectivity.
* Do not install Docker Engine.
* Install [Terraform](https://www.terraform.io/downloads.html).
* Install [Docker Toolbox](https://github.com/docker/toolbox/releases/tag/v1.12.5) (pkg file for Mac).
* Install [docker-machine](https://docs.docker.com/machine/install-machine/) (Only do Steps 2 and 3.
* Install [docker-compose](https://docs.docker.com/compose/install/) (Only do Steps 4 to 7).
* Creating a Floating IP in RAC. Skip if you already have one you can use.
* Create a security group in RAC that allows all traffic (all tcp, udp, icmp, ipv4, ipv6). Skip if you already have one.

## Deployment

* Clone this repository to your desktop: `git clone https://github.com/jtopjian/terraform-swarm`.
* Change to that directory: `cd terraform-swarm`.
* Clone the https://github.com/jpetazzo/orchestration-workshop repo: `git clone https://github.com/jpetazzo/orchestration-workshop`
* Create a key in the `key` directory: `cd terraform-swarm/key; ssh-keygen -t rsa -N '' -f id_rsa`.
* Edit `main.tf` and replace `CHANGEME` with your Floating IP and your Security Group name.
* Run `terraform apply`.
* If you need to start from scratch, run `bash files/destroy.sh`.

## Slides

* Slides 1-45 are helpful to read, but you don't need to do the work.
* Terraform takes care of all work between slides 46-88.
* Begin hands-on work at slide 89.
* When the instructions ask to go to verify a port or open a page, use your floating IP.
* Replace `localhost:5000` with `<floating-ip>:5000` when interacting with the Docker registry.
* The instructions for the individual `snapd` instance works -- do it.
* The instructions for the `snapd` cluster are broke -- skip it.
* Skip anything requiring Docker 1.13.

## Connecting to Nodes

Use `docker-machine` to easily SSH to nodes:

```shell
$ docker-machine ssh swarm-manager
$ docker-machine ssh swarm-worker-01
$ docker-machine ssh swarm-worker-02
```

## Helper Snippets

Add these bash funtions to `~/.bashrc` to make using `docker-machine` easier:

```bash
dock() {
  eval $(docker-machine env $1)
}

undock() {
  unset DOCKER_HOST
  unset DOCKER_MACHINE_NAME
  unset DOCKER_TLS_VERIFY
  unset DOCKER_CERT_PATH
}
```

Then `source ~/.bashrc`.

You can then begin interacting with the swarm-manager by doing:

```shell
$ dock swarm-manager
$ docker node ls
```

When you're finished:

```shell
$ undock swarm-manager
```
