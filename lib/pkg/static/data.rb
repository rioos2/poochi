require 'pkg/version'
require 'colorize'

module Pkg::Data
  include Pkg::Version

  CLOUD = 'cloud'.freeze
  CURRENT_GIT_TAG   = Pkg::Config.git_tag

  def self.COMMON
    puts "=> Packaging: [#{COMMON} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:cyan).bold
    {
      package: COMMON,
      description: %(This is an empty package that creates the group and user, and the
    base directories  for #{BASIC[:product]}.),
      category: CLOUD
    }
  end

  def self.NILAVU
    puts "=> Packaging: [#{NILAVU} #{BASIC[:version]}:#{BASIC[:iteration]}] ".colorize(:green).bold

    {
      package: NILAVU,
      from: 'node:9.8.0-alpine',
      description: %(Description: The UI for #{BASIC[:product]}.),
      category: 'cloud',
      deb_dependencies: "yarn",
      tar: 'https://nodejs.org/dist/v9.8.0/node-v9.8.0-linux-x64.tar.gz',

      git: 'git@gitlab.com:rioos/nilavu',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      systemd_service: "#{NILAVU}.service",

    }.freeze
  end

  def self.CONTROLLER
    puts "=> Packaging: [#{CONTROLLER} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: CONTROLLER,
      from: 'busybox:ubuntu-14.04',
      description: %(Description: Control Manager for #{BASIC[:product]}.),
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      tar: 'https://gitlab.com/rioos/gitpackager/raw/master/support/init2.0.sh?private_token=jGhxy47oEZpNyTHggpJB',

      systemd_service: "#{CONTROLLER}.service"
    }
  end

  def self.ARANCLI
    puts "=> Packaging: [#{ARANCLI} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: ARANCLI,
      description: %[Description: CLI  for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}'

    }
  end

  def self.NODELET
    puts "=> Packaging: [#{NODELET} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: NODELET,
      description: %[Description: Rio/OS node agent which provides scheduling,
      provisioning, realtime log streaming, events handling functions for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: "libvirt-bin, libguestfs-tools, qemu-kvm",

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      tar: 'https://gitlab.com/rioos/gitpackager/raw/master/support/init2.0.sh?private_token=Y_ERcx_p7sec1dksTesJ',

      systemd_service: "#{NODELET}.service"
    }
  end

  def self.STORLET
    puts "=> Packaging: [#{STORLET} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: STORLET,
      description: %[Description: Rio/OS storage agent which provides storage management,
      provisioning, storage pool based on the supported providers.],
      category: CLOUD,
      dependencies: "",

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      systemd_service: "#{STORLET}.service"
    }
  end

  def self.ARAN
    puts "=> Packaging: [#{ARAN} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: ARAN,
      from: 'debian:stretch-slim',
      description: %[Description: API server for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      systemd_service: "#{ARAN}.service"
    }
  end

  def self.MARKETPLACE
    puts "=> Packaging: [#{MARKETPLACE} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: MARKETPLACE,
      from: 'debian:stretch-slim',
      description: %[Description: Marketplace  for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      systemd_service: "#{MARKETPLACE}.service"
    }
  end

  def self.BLOCKCHAIN
    puts "=> Packaging: [#{BLOCKCHAIN} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: BLOCKCHAIN,
      from: 'debian:stretch-slim',
      description: %[Description: API server for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      systemd_service: "#{BLOCKCHAIN}.service"
    }
  end

  def self.PROMETHEUS
    puts "=> Packaging: [#{PROMETHEUS} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: PROMETHEUS,
      from: 'busybox:ubuntu-14.04',
      description: 'Metrics collector for #{BASIC[:product]}',
      category: CLOUD,
      dependencies: "",

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      systemd_service: "#{PROMETHEUS}.service"
    }.freeze
  end

  def self.NETWORK
    puts "=> Packaging: [#{NETWORK} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: NETWORK,
      description: %[Description: Used to create network bridge using OpenvSwitch, it connects #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: 'openvswitch-switch',
      tag: '#{GIT_TAG}',

      systemd_service: "#{NETWORK}.service"
    }
  end

  def self.BOOTSTRAP
    puts "=> Packaging: [#{BOOTSTRAP} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: BOOTSTRAP,
      description: %[Description: Agent boortstap which helps to setup networking inside
      digital cloud for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',
      tag: '#{GIT_TAG}',

      systemd_service: "#{BOOTSTRAP}.service"
    }
  end

  def self.GULPD
    puts "=> Packaging: [#{GULPD} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: GULPD,
      description: %[Description: Agent which provides instrumentation for digital cloud for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: COMMON.to_s,

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      # The service name to start
      systemd_service: "#{GULPD}.service",
      upstart_service: GULPD.to_s,
      # Turn this flag on if you don't want to upload to cloud storage like S3
      skip_upload: false
    }
  end

  def self.VNC
    puts "=> Packaging: [#{VNC} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: VNC,
      from: 'node:8.7.0-alpine',
      description: %(Nodejs based VNC server for #{BASIC[:product]}),
      category: CLOUD
      # download the tar binary
      git: 'https://gitlab.com/rioos/vncserver.git',
      git_org: 'gitlab.com/rioos',
      tag: '#{GIT_TAG}',

      tar: 'https://nodejs.org/dist/v8.6.0/node-v8.6.0-linux-x64.tar.xz',

      # The service name to start
      systemd_service: "#{VNC}.service",
      upstart_service: VNC.to_s
    }
  end

  def self.FLUENTBIT
    puts "=> Packaging: [#{FLUENTBIT} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: FLUENTBIT,
      version: '0.12.11',
      from: 'gcr.io/google-containers/debian-base-amd64:0.1',
      description: 'Fluent Bit docker image for Rio/OS v2',

      category: 'cloud',
      # download the tar binary
      git: 'https://github.com/fluent/fluent-bit.git',
      git_org: 'gitlab.com/rioos',
      branch: 'master',

      # The service name to start
      systemd_service: "#{FLUENTBIT}.service",
      upstart_service: FLUENTBIT.to_s
    }
  end

  def self.INFLUXDB
    {
      version: '1.3.7',
      from: 'buildpack-deps:stretch-curl',
      description: 'InfluxDb docker image for Rio/OS v2',
      metadir: '/var/lib/influxdb/meta',
      datadir: '/var/lib/influxdb/data',
      engine: 'tsm1',
      waldir: '/var/lib/influxdb/wal'
    }
  end

  def self.POWERDNS
    {
      version: '4.0.3',
      from: 'alpine:edge',
      description: 'PowerDNS docker image for Rio/OS v2',
    }
  end

  def self.VULCAND
    {
      from: 'webhippie/alpine:latest',
      description: 'Vulcand docker image for Rio/OS v2',
    }
  end

  def self.RETHINKDB
    {
      from: 'debian:jessie',
      description: 'RethinkDB docker image for Rio/OS v2',
      version: '2.3.6~0jessie',
    }
  end

  def self.APACHE
    {
      from: 'debian:jessie',
      description: 'Apache docker image for Rio/OS v2',
      version: '2.2.34',
    }
  end

  def self.VOLTDB
    {
      from: 'ubuntu:14.04',
      description: 'Voltdb docker image for Rio/OS v2',
      version: '7.8.2',
    }
  end

  def self.NEO4J
    {
      from: 'openjdk:8-jre-alpine',
      description: 'Neo4J docker image for Rio/OS v2',
      version: '3.3.1',
    }
  end

  def self.MARIADB
    {
      from: 'debian:jessie',
      description: 'MariaDB docker image for Rio/OS v2',
      major: '10.3',
      version: '10.3.2',
    }
  end

  def self.AEROSPIKE
    {
      from: 'ubuntu:xenial',
      description: 'Aerospike docker image for Rio/OS v2',
      sha256: 'beb45dd20205624e7d8e08456c57cb0b3c18c3a643ef8246f2c6dedf1a964631',
      version: '3.15.0.2',
    }
  end

  def self.COUCHDB
    {
      from: 'debian:jessie',
      description: 'CouchDB docker image for Rio/OS v2',
      version: '2.1.1',
    }
  end

  def self.POSTGRES
    {
      from: 'alpine:3.6',
      major: '10',
      version: '10.1',
      sha256: '3ccb4e25fe7a7ea6308dea103cac202963e6b746697366d72ec2900449a5e713',
      description: 'PostgreSQL docker image for Rio/OS v2',
    }
  end

  def self.CASSANDRA
    {
      from: 'debian:jessie-backports',
      description: 'Cassandra docker image for Rio/OS v2',
      version: '3.11.1',
    }
  end

  def self.NGINX
    {
      from: 'debian:stretch-slim',
      description: 'Nginx docker image for Rio/OS v2',
      version: '1.13.7-1~stretch',
    }
  end

  def self.ORIENTDB
    {
      from: 'openjdk:8-jdk',
      description: 'orientdb docker image for Rio/OS v2',
      version: '2.0.18',
    }
  end

  def self.REDIS
    {
      from: 'debian:jessie-slim',
      description: 'redis docker image for Rio/OS v2',
      version: '3.2.11',
    }
  end

  def self.MARIADB
    {
      from: 'debian:jessie',
      description: 'MariaDB docker image for Rio/OS v2',
      major: '10.3',
      version: '10.3.2',
    }
  end
  def self.MEMCACHED
    {
      from: 'alpine:3.6',
      description: 'Memcached docker image for Rio/OS v2',
      version: '1.5.3',
    }
  end

  def self.COCKROACHDB
    {
      from: 'busybox:ubuntu-14.04',
      version: '1.1.3',
      description: 'CockroachDB docker image for Rio/OS v2',
    }
  end
end
