Poochi
=====

Poochi helps to build/ship packages (Aventura, Docker) of Rio/OS.

![Poochi Radiant](https://gitlab.com/rioos/poochi/raw/master/images/bug_happysailing.gif)

## Best practices
We are glad to see our approach followed in `gitlab` or `puppet`.

[Gitlab release mgmt](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/release/README.md)

[Puppet release mgmt](https://github.com/puppetlabs/packaging/blob/master/README.md)

# Release Management

Our main goal is to make it clear which version of Rio/OS is in the package.


![Packages tree](https://gitlab.com/rioos/poochi/raw/master/images/autopackages.png)

## How is the official Rio/OS package built

The official package build is fully automated by Rio Advancement Inc.

We can differentiate between two types of build:

* Packages for release/stable to get.rioos.xyz
* Packages for testing        to get.rioos.io/testing

and

* Container for release to registry.rioos.xyz

Both types are built on the same infrastructure.

## Infrastructure

Each package is built on the platform in Ubuntu Xenial using fpm.

The poochi projectt fully utilizes GitLab CI. This means that each push
to poochi repository will trigger a build in GitLab CI which will
then create a package.

This remote is located on build.rioos.xyz.

All build servers run [gitlab runner] and all runners use a deploy key to connect to the projects on [gitlab.org/rioos](https://gitlab.com/rioos).

The build servers also have access to a special [registry Rio/OS](https://registry.rioos.xyz) which stores the container tar balls.

# Process

Rio Advancement is using the [poochi](https://gitlab.com/rioos/poochi) to automate the release tasks for every release. When the release manager starts the release process, a couple of important things for poochi will be done:

1. A specific Git tag will be created and synced to poochi repositories using [ottavada](https://gitlab.com/rioos/ottavada)

## Ottavada

Release manager uses [ottavada](https://gitlab.com/rioos/ottavada.git) to create a tag. Read the documentation of [ottadava](https://gitlab.com/rioos/ottavada.git) to start the tag process.

All the main repositories [beedi](https://gitlab.com/rioos/beedi), [nilavu](https://gitlab.com/rioos/nilavu), [aran](https://gitlab.com/rioos/aran) are tagged with the versions.

A slack notification is received when the tagging is complete.

## Poochi

When the poochi repository on  gets updated, GitLab CI build gets triggered. The builds are performed on [build.rioos.xyz](build.rioos.xyz).

The specific steps can be seen in `.gitlab-ci.yml` file in [poochi](https://gitlab.com/rioos/poochi).

During the build, poochi will pull external libraries from their source locations and Rio/OS components like nilavu, beedi, aran.

Once the build completes and the .deb, containers, aventura ISO are built.

### Deb

The deb packages are pushed to  a debian repository  [get.rioos.xyz](get.rioos.xyz) served by nginx.

### Containers  of Rio/OS

The containers are pushed to [registry.rioos.xyz](https://registry.rioos.xyz).

### Containers for Rio/OS Marketplace

The containers tar balls are rsynced to [marketplace.rioos.xyz](marketplace.rioos.xyz). They are then copied over to the correct location in the [marketplace.rioos.xyz](marketplace.rioos.xyz).


### Publishing

You can track the progress of package building on [poochi](https://gitlab.com/rioos/poochi).

They are pushed to [get.rioos.xyz repositories](https://get.rioos.xyz) automatically after successful builds.

[gitlab runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner)

[get.rioos.xyz repositories](https://get.rioos.xyz)

### Build infrastructure prereqs

- Ubuntu 18.04
- Ruby 2.5.x via [rvm]
- Node.js  [9.10.x](https://nodejs.org/en/)
- Golang [1.10.x](https://golang.org/dl/)
- Rustlang [1.24.x](https://rust-lang.org)

### Prereqs: Installation

Note: This will be automated by `poochi`

```
mkdir ~/downloads
mkdir ~/software

```

### Nodejs

```
cd ~/downloads

https://nodejs.org/dist/v9.11.1/node-v9.11.1-linux-arm64.tar.gz

tar -xvf node-v9.11*

mv node-v9.11* ~/software

mv ~/software/node-v9.11* ~/software/node

```

### Yarn

```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn

```

### Golang

```
cd ~/downloads

wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz

tar -xvf go1.10*

mv go1.10* ~/software

mv ~/software/go-1.10*/go ~/software/go

```

### Rust

```
curl https://sh.rustup.rs -sSf | sh

```

### Openssl

```
sudo -s

cd /usr/local/src && apt install gcc make -y

wget https://www.openssl.org/source/openssl-1.1.0h.tar.gz && tar xzvf openssl-1.1.0h.tar.gz && cd openssl-1.1.0h

./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'

make

make install

##Reboot the server
shutdown -r now

```

### RocksDB

```
$ sudo apt install build-essential libsodium-dev librocksdb-dev libsnappy-dev \
    libssl-dev pkg-config
```

### Docker

```
$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo apt-key fingerprint 0EBFCD88

$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable edge"

$sudo apt-get update

$ sudo apt-get install docker-ce


```

### Configure .bashrc

You will have configure .bashrc with the `PATH` updated for `golang`, `cargo`, `nodejs`.

```

$ nano .bashrc

export SOFTWARE_HOME=$HOME/software

PATH="$PATH:$SOFTWARE_HOME/node/bin:$SOFTWARE_HOME/go/bin:$HOME/.cargo/bin"  

```

Save the file, and run this from the same terminal, (or) open a new terminal for the .bashrc PATH to get reloaded.

```

source ~/.bashrc

```

### Install Gitlab Runner

```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

sudo apt-get install gitlab-runner

```

### Register the runner

```

sudo gitlab-runner register

```
##Following specify the information to register the runner:

1.Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com ):
```
https://gitlab.com
```

2.Please enter the gitlab-ci token for this runner
###Enter the poochi token id
```
M88_FuzKqdQ4cSKTjAtG
```

3.Please enter the gitlab-ci description for this runner
##runner name to view in poochi
```
build01-rioos
```

4.Please enter the gitlab-ci tags for this runner (comma separated):
```
rioos
```

5.Whether to run untagged jobs [true/false]:
```
false
```

6.Whether to lock Runner to current project [true/false]:
```
true
```

7.Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell:
```
docker
```

8.Please enter the Docker image (eg. ruby:2.1):
```
alpine:latest
```

After that 'Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!'

check the new runner created in the poochi `settings -> CI/CD  -> Runners Settings`

## Using the Packaging Repo

The tasks are generally grouped into category

- `package:`

## `package` tasks

`package` tasks are general purpose tasks that are set up to use the most minimal tool
chain possible for creating packages. These tasks will create debs but any
build dependencies will need to be satisifed by the building host, and any dynamically
generated dependencies may result in packages that are only suitable for the
OS/version of the build host.

- To build a deb, go to the component you wish to build

```

cd rio_nilavu

rake aventura

```

- To build a docker container, go to the component you wish to build.

```
cd rio_nilavu

rake clean

rake docker

```

Everything gets built by the CI.


# License

Rio Advancement Inc


# Authors

Humans @ Rio Advancement (<dev@rio.company>)
