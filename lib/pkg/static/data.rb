require 'pkg/version'
require 'colorize'

module Pkg::Data
  include Pkg::Version

  CLOUD = 'cloud'.freeze

  ## Unable to load version from  BASIC, hence this hack.
  def self.init
    BASIC[:version] = Pkg::Config.git_tag
    BASIC[:registry_url] = Pkg::Config.docker_registry
    BASIC[:registry_username] = Pkg::Config.docker_registry_username
    BASIC[:registry_password] = Pkg::Config.docker_registry_password
    BASIC[:iteration] = Pkg::Config.packaging_iteration
  end

  ## Call the init so we could get the version
  self::init

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
      from: 'node:9.10.1-alpine',
      description: %(Description: The UI for #{BASIC[:product]}.),
      category: 'cloud',
      deb_dependencies: "yarn",
      tar: 'https://nodejs.org/dist/v9.10.1/node-v9.10.1-linux-arm64.tar.gz',

      git: 'git@gitlab.com:rioos/nilavu',
      git_org: 'gitlab.com/rioos',

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

      systemd_service: "#{CONTROLLER}.service"
    }
  end

  def self.SCHEDULER
    puts "=> Packaging: [#{SCHEDULER} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: SCHEDULER,
      from: 'busybox:ubuntu-14.04',
      description: %(Scheduler used to schedule a job for #{BASIC[:product]}.),
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',

      systemd_service: "#{SCHEDULER}.service"
    }
  end

  def self.ARANCLI
    puts "=> Packaging: [#{ARANCLI} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: ARANCLI,
      description: %[Description: CLI  for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',
      # Rioos dolphin, bot users private github token
      github_private_token: 'be648bc18a5c5418deaca03ff9934aa6cf14084b',

      git: 'git@gitlab.com:rioos/aran.git',
      git_org: 'gitlab.com/rioos'
    }
  end

  def self.NODELET
    puts "=> Packaging: [#{NODELET} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: NODELET,
      description: %[Rio/OS node agent which provides scheduling,
      provisioning, realtime log streaming, events handling functions for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: "libvirt-dev, libguestfs-dev, librbd-dev",

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',

      tar: 'https://gitlab.com/rioos/poochi/raw/2-0-stable/support/init2.0.sh?private_token=JgH4PaKVpuJM3yRidaS9',

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
      dependencies: "librbd-dev",

      git: 'git@gitlab.com:rioos/beedi.git',
      git_org: 'gitlab.com/rioos',

      systemd_service: "#{STORLET}.service"
    }
  end

  def self.API
    puts "=> Packaging: [#{API} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: API,
      from: 'debian:stretch-slim',
      description: %[Description: API server for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran',
      git_org: 'gitlab.com/rioos',

      systemd_service: "#{API}.service"
    }
  end

  def self.MARKETPLACE
    puts "=> Packaging: [#{MARKETPLACE} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: MARKETPLACE,
      from: 'debian:stretch-slim',
      description: %[Description: Marketplace for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran.git',
      git_org: 'gitlab.com/rioos',

      systemd_service: "#{MARKETPLACE}.service"
    }
  end

  def self.BLOCKCHAIN
    puts "=> Packaging: [#{BLOCKCHAIN} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: BLOCKCHAIN,
      from: 'debian:stretch-slim',
      description: %[Description: Audits Blockchain server for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

      git: 'git@gitlab.com:rioos/aran.git',
      git_org: 'gitlab.com/rioos',

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

      systemd_service: "#{PROMETHEUS}.service"
    }.freeze
  end

  def self.VNETWORK
    puts "=> Packaging: [#{VNETWORK} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: VNETWORK,
      description: %[Used to create network bridge using OpenvSwitch, it connects #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: 'openvswitch-switch',

      systemd_service: "#{VNETWORK}.service"
    }
  end

  def self.BOOTSTRAP
    puts "=> Packaging: [#{BOOTSTRAP} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: BOOTSTRAP,
      description: %[Agent bootstrap which helps to setup networking inside
      digital cloud for #{BASIC[:product]}.],
      category: CLOUD,
      dependencies: '',

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
      from: 'node:9.10.1-alpine',
      description: %(Console for digital cloud for #{BASIC[:product]}),
      category: CLOUD,
      # download the tar binary
      git: 'git@gitlab.com:rioos/vncserver.git',
      git_org: 'gitlab.com/rioos',

       tar: 'https://nodejs.org/dist/v9.11.1/node-v9.11.1-linux-arm64.tar.gz',

      # The service name to start
      systemd_service: "#{VNC}.service",
      upstart_service: VNC.to_s
    }
  end


  def self.FLUENTBIT
    puts "=> Packaging: [#{FLUENTBIT} #{BASIC[:version]}:#{BASIC[:iteration]}]".colorize(:green).bold
    {
      package: FLUENTBIT,
      version: '0.12.15',
      from: 'gcr.io/google-containers/debian-base-amd64:0.1',
      description: 'Logger shipper responsbile for shipping digitalcloud, container, apps logs for #{BASIC[:product]} v2',

      category: CLOUD,

      git: 'https://github.com/fluent/fluent-bit.git',
      git_org: 'gitlab.com/rioos',

      systemd_service: "#{FLUENTBIT}.service",
    }
  end

  def self.INFLUXDB
    {
      version: '1.3.7',
      from: 'buildpack-deps:stretch-curl',
      description: 'InfluxDb docker image for #{BASIC[:product]} v2',
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
      description: 'DNS for digitalcloud, container, blockchain for #{BASIC[:product]} v2',
    }
  end

  def self.VULCAND
    {
      from: 'webhippie/alpine:latest',
      description: 'Load balancer for #{BASIC[:product]} v2',
    }
  end

  def self.RETHINKDB
    {
      from: 'debian:jessie',
      description: 'Rio.Marketplace: Database, RethinkDB for #{BASIC[:product]} v2',
      version: '2.3.6~0jessie',
    }
  end

  def self.APACHE
    {
      from: 'alpine:3.6',
      description: 'Rio.Marketplace: Apache webserver for #{BASIC[:product]} v2',
      version: '2.4.33',
      sha256: 'de02511859b00d17845b9abdd1f975d5ccb5d0b280c567da5bf2ad4b70846f05',
    }
  end

  def self.VOLTDB
    {
      from: 'ubuntu:14.04',
      description: 'Rio.Marketplace: Database, VoltDB for #{BASIC[:product]} v2',
      version: '7.8.2',
    }
  end

  def self.NEO4J
    {
      from: 'openjdk:8-jre-alpine',
      description: 'Rio.Marketplace: Neo4J docker image for #{BASIC[:product]} v2',
      version: '3.3.1',
    }
  end

  def self.MARIADB
    {
      from: 'debian:jessie',
      description: 'Rio.Marketplace: MariaDB docker image for #{BASIC[:product]} v2',
      major: '10.3',
      version: '10.3.5+maria~jessie',
    }
  end

  def self.AEROSPIKE
    {
      from: 'ubuntu:xenial',
      description: 'Rio.Marketplace: Aerospike docker image for #{BASIC[:product]} v2',
      sha256: 'beb45dd20205624e7d8e08456c57cb0b3c18c3a643ef8246f2c6dedf1a964631',
      version: '3.15.0.2',
    }
  end

  def self.COUCHDB
    {
      from: 'debian:jessie',
      description: 'Rio.Marketplace: CouchDB docker image for #{BASIC[:product]} v2',
      version: '2.1.1',
    }
  end

  def self.POSTGRES
    {
      from: 'alpine:3.7',
      major: '10',
      version: '10.3',
      sha256: '6ea268780ee35e88c65cdb0af7955ad90b7d0ef34573867f223f14e43467931a',
      description: 'Rio.Marketplace: PostgreSQL docker image for #{BASIC[:product]} v2',
    }
  end

  def self.CASSANDRA
    {
      from: 'debian:stretch-slim',
      description: 'Rio.Marketplace: Cassandra docker image for #{BASIC[:product]} v2',
      version: '3.11.2',
    }
  end

  def self.NGINX
    {
      from: 'alpine:3.7',
      description: 'Rio.Marketplace: Nginx docker image for #{BASIC[:product]} v2',
      version: '1.13.11',
    }
  end

  def self.ORIENTDB
    {
      from: 'openjdk:8-jdk',
      description: 'Rio.Marketplace: Orientdb docker image for #{BASIC[:product]} v2',
      version: '2.0.18',
    }
  end

  def self.REDIS
    {
      from: 'debian:jessie-slim',
      description: 'Rio.Marketplace: redis docker image for #{BASIC[:product]} v2',
      version: '3.2.11',
    }
  end

  def self.MARIADB
    {
      from: 'debian:jessie',
      description: 'Rio.Marketplace: MariaDB docker image for #{BASIC[:product]} v2',
      major: '10.3',
      version: '10.3.2',
    }
  end
  def self.MEMCACHED
    {
      from: 'alpine:3.6',
      description: 'Rio.Marketplace: Memcached docker image for #{BASIC[:product]} v2',
      version: '1.5.3',
    }
  end

  def self.COCKROACHDB
    {
      from: 'busybox:ubuntu-14.04',
      version: '1.1.3',
      description: 'Rio.Marketplace: CockroachDB docker image for #{BASIC[:product]} v2',
    }
  end
end
