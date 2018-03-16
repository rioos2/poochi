# Support scripts

## Docker image build

Build a Docker images for Rio/OS v2 and push into Private Registry.

###  Pre-requisites

**Note** You need to login into private registry

```
$ wget https://s3.amazonaws.com/rioos/registry/ca.crt

$ sudo -s

$ export CA_CRT=$PWD/ca.crt

$ mkdir -p /etc/docker/certs.d/registry.rioos.xyz:5000

$ mv $CA_CRT /etc/docker/certs.d/registry.rioos.xyz:5000

$ exit

$ docker login registry.rioos.xyz:5000

```
**userid** `rioosadmin`
**password** `team4rio`


### Sample RethinkDB image build

Get RethinkDB Dockerfile in [DockerHub](https://hub.docker.com/_/rethinkdb/)

Steps to build docker image

* Clone gitpackager.

* Install required gem.

* Create directory in marketplace repository.

* Download `wget` Dockerfile onto newly created directory.

```
$ git clone https://gitlab.com/rioos/poochi.git

$ cd poochi

$ bundle install

$ mkdir -p marketplaces/rethinkdb

$ cd marketplaces/rethinkdb

$ wget -O Dockerfile.erb https://raw.githubusercontent.com/rethinkdb/rethinkdb-dockerfiles/05946c0dbe3c7fa9338d3827428b2c32074a1447/jessie/2.3.6/Dockerfile

```
* Copy existing rethinkdb repository and customize your needs.

* Create dockerfile customizable variables in lib/pkg/static/data file.

```
def self.RETHINKDB
  {
    from: 'debian:jessie',
    description: 'RethinkDB docker image for Rio/OS v2',
    version: '2.3.6~0jessie',
  }
end

```
Here, i used RethinkDB support OS, Description and version are provided in customizable way.


* Changes in Rakefile

```
Pkg::Builder.new(Pkg::Common.distro_dir, Pkg::Common.distro_build_dir, Pkg::Data.RETHINKDB).exec

```

Point your customizable marketplace_item name.

* Change suitable name for docker images in g.erb file

```

sudo docker build -t rio-rethinkdb -f Dockerfile .

sudo docker tag rio-rethinkdb <%= @basic[:registry_url]+"/rioosrethinkdb:"+@package[:version] %>

sudo docker push <%= @basic[:registry_url]+"/rioosrethinkdb:"+@package[:version] %>

```

* Build docker image using `rake` command in `marketplaces/rethinkdb` repository

using `rake docker` command to start build docker image.

using `rake clean` command to clean build repositories.

Now, You can successfully build rethinkdb docker images and push into private registry.


## letsencrypt

LetsEncrypt is a certificate authority that  provides free X.509 certificates via an automated process.

We provide a LetsEncrypt wrapper shell script which can be downloaded into any directory.

Please make sure you have a valid `public domain` and `public ip address`.


```bash

wget https://raw.githubusercontent.com/megamsys/gitpackager/master/support/letsencrypt

chmod 0755 letsencrypt

# install the letsencrypt certificate
./letsencrypt --install  <domainame> <domainip>

# remove the letsencrypt certificate
./letsencrypt --remove <domainname>

# renewal the letsencrypt certificate
./letsencrypt --autorenew <domainname>

````
