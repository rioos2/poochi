Muddy
=====

Muddy helps to build/ship packages (Ubuntu, Docker) of Rio/OS.

## Best practices

[Gitlab release mgmt](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/release/README.md)

[Puppet release mgmt](https://github.com/puppetlabs/packaging/blob/master/README.md)


# Packaging

This is a repository for packaging automation of Rio/OS software. We are glad to see our approach followed in `gitlab` or `puppet` hence we decided to extend the `gitpackager` to the next level.

Here we are `muddy` is born.

## Tree

![Packages tree](https://gitlab.com/megamsys/gitpackager/blob/master/images/autopackages.png)

1. Ubuntu 18.04
2. Docker

## Prereqs

- 18.04
- Ruby 2.5.x via [rvm]
- Node.js  [8.10.x](https://nodejs.org/en/)
- Golang [1.10.x](https://golang.org/dl/)
- Rustlang [1.24.x](https://rust-lang.org)

## Prereqs: Installation

Note: This will be automated by `muddy`

```
mkdir ~/downloads
mkdir ~/software

```

### Nodejs
```
cd ~/downloads
wget https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-arm64.tar.gz

tar -xvf node-v8.10*

mv node-v8.10* ~/software
mv ~/software/node-v8.10* ~/software/node

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
### Rustlang

```
curl https://sh.rustup.rs -sSf | sh

```

### Openssl

```
sudo -s

cd /usr/local/src && apt install gcc make -y

wget https://www.openssl.org/source/openssl-1.1.0g.tar.gz && tar xzvf openssl-1.1.0g.tar.gz && cd openssl-1.1.0g

./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'

make

make install

##CAUTION - Reboot the server
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

## Configure .bashrc

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
##install gitlab runners
```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

sudo apt-get install gitlab-runner
```
## Register the runner
```
sudo gitlab-runner register
```
##Following specify the information to register the runner:
1.Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com ):
```
https://gitlab.com
```
2.Please enter the gitlab-ci token for this runner
###Enter the gitpackager token id
```
M88_FuzKqdQ4cSKTjAtG
```
3.Please enter the gitlab-ci description for this runner
##runner name to view in gitpackager
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
###After that 'Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!'

##check the new runner created in the git packager
#settings -> CI/CD  -> Runners Settings
#show Specific runner list

## Using the Packaging Repo

The tasks are generally grouped into category
- `package:`

## `package` tasks

`package` tasks are general purpose tasks that are set up to use the most minimal tool
chain possible for creating packages. These tasks will create rpms and debs, but any
build dependencies will need to be satisifed by the building host, and any dynamically
generated dependencies may result in packages that are only suitable for the
OS/version of the build host.

- To build a deb, do `rake ubuntu`.

- To build a rpm, do `rake centos`.

# Rio/OS release process

Our main goal is to make it clear which version of Rio/OS is in the package.

# How is the official Rio/OS package built

The official package build is fully automated by Rio Advancement Inc.

We can differentiate between two types of build:

* Packages for release to get.rioos.xyz
* Packages for test to get.rioos.io/testing

and

* Container for release to registry.rioos.xyz

Both types are built on the same infrastructure.

## Infrastructure

Each package is built on the platform in Ubuntu Xenial using fpm.

The gitpackager projectt fully utilizes GitLab CI. This means that each push
to gitpackager repository will trigger a build in GitLab CI which will
then create a package.

This remote is located on build.rioos.xyz.

All build servers run [gitlab runner] and all runners use a deploy key
to connect to the projects on [gitlab.org/rioos](https://gitlab.com/rioos).

The build servers also have access to a special [registry Rio/OS](https://registry.rioos.xyz) which stores the container tar balls.

## Build process

Rio Advancement is using the [gitpackager](https://gitlab.com/rioos/gitpackager) to automate the release tasks for every release. When the release manager starts the release process, a couple of important things for gitpackager will be done:

1. All remotes of the project will be synced
2. A specific Git tag will be created and synced to gitpackager repositories

When the gitpackager repository on [build.rioos.xyz](build.rioos.xyz) gets updated, GitLab CI build gets triggered.

The specific steps can be seen in `.gitlab-ci.yml` file in gitpackager
repository. The builds are executed on all platforms at the same time.

During the build, gitpackager will pull external libraries from their source
locations and Rio/OS components like nilavu, beedi, aran.

Once the build completes and the .deb or .rpm packages, containers are built, depending on the build type package will be pushed to [get.rioos.xyz](get.rioos.xyz) and [regstry.rioos.xyz](registry.rioos.xyz).

## Specifying component versions manually
### On your development machine

1. Pick a tag of Rio/OS to package (e.g. `v2.0.0.rc0`).
2. Create a release branch in gitpackager (e.g. `2.0.0.rc0`).
4. If the release branch already exists, for instance because you are doing a
  patch release, make sure to pull the latest changes to your local machine:

    ```
    git pull https://gitlab.com/rioos/gitpackager 2.0.0 # existing release branch
    ```

1. Use `support/set-revisions` to set the revisions of files in
  `config/software/`. It will take tag names and look up the Git SHA1's, and set
  the download sources to get.rioos.xyz.

    ```
    # usage: set-revisions <Rio/OS release version>

    # For Rio/OS 2.0.0.rc0:
    support/set-revisions v2.0.0.rc0

    ```

2. Commit the new version to the release branch:

    ```shell
    git add VERSION
    git commit
    ```

3. Create an annotated tag on gitlab corresponding to the Rio/OS tag.
  The gitpackager tag looks like: `MAJOR.MINOR.PATCH+OTHER.GITPACKAGER_RELEASE`, where
  `MAJOR.MINOR.PATCH` is the Rio/OS version, `OTHER` can be something like `rc1` (or `rc2`), and `GITPACKAGER_RELEASE` is a number (starting at 0):

    ```shell
    git tag -a 2.0.0+rc0.0 -m 'Pin Rio/OS to v2.0.0.rc0'
    ```

    **WARNING:** Do NOT use a hyphen `-` anywhere in the gitpackager tag.

    Examples of converting an upstream version tag to an gitpackager tag sequence:

| upstream tag     | gitpackager tag sequence                    |
|------------------|---------------------------------------------|
| `v2.0.rc1`       | `2.0+rc1.0`, `2.0+rc1.1`,       `...`       |
| `v2.0.0`         | `2.0+stable.0`, `2.0+stable.1`, `...`       |
| `v2.0.1`         | `2.0.1+stable.0`, `2.0.1+stable.1`, `...`   |


5. Push the branch and the tag to github.com:

    ```shell
    git push git@github.com/rioos/gitpackager.git 2-0-0-rc1 2.0.0+rc0.0
    ```

    Pushing an annotated tag to github.com triggers a package release.

### Publishing the packages

You can track the progress of package building on [gitpackager](https://gitlab.com/rioos/gitpackager).
They are pushed to [get.rioos.xyz repositories](https://get.rioos.xyz) automatically after successful builds.

[release-tools project](https://github.com/rioos/gitpackager)

[gitlab runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner)

[get.rioos.xyz repositories](https://get.rioos.xyz)

We have notifiers to slack channel [#releng]

### Type the url `https://get.rioos.xyz`  You'll see the refreshed packages

[Coming  - soon : Notifiers via Android app]


# License

MIT


# Authors

Humans Rio Advancement (<dev@rio.company>)