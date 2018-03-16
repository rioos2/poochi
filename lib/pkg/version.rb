require 'pkg/tools'

module Pkg
  module Version
    ### Please configure (STEPS BASIC, 1, 2, 3) to whitelable builds

    # BASIC: Configure the tool versions to use
    # golang: go version  | grep 1.10 > /dev/null
    # node: node version | grep 9.7 > /dev/null
    COMPILE = {
     # golang:  {cmd: 'go version  | grep 1.10 > /dev/null', link: "Installing https://golang.org/dl"},
     # node:    {cmd: 'node -v | grep 9.7 > /dev/null', link: "Installing https://nodejs.org/en/"},
      yarn:    {cmd: 'yarn -v | grep 1.5 > /dev/null', link: "Installing http://bit.ly/gitpyarni"},
      rustc:   {cmd: 'rustc -V | grep 1.24.1 > /dev/null', link: "Installing http://bit.ly/gitprustci"},
     # docker:  {cmd: 'docker -v | grep 18 > /dev/null', link: "Uninstalling http://bit.ly/gitpdocku, Installing: http://bit.ly/gitpdocki" }
     }.freeze

    ## check if  required tools are installed
    Pkg::Tools.new.check?(COMPILE)

    ## All of these can be loaded using a YAMLLoader (build_data.yml)
    ## Default operation system supported
    SUPPORTED_OS = { os: %w[xenial centos7] }.freeze

    ## STEP 1: Configure directories
    # change the name to your own downstream fork.
    # eg:
    # HOME    = "/usr/share/megam"
    # LIBHOME = "/var/lib/megam"
    # LOGHOME = "/var/log/megam"
    # RUNHOME = "/var/run/megam"
    HOME     = '/usr/share/rioos'.freeze
    LIBHOME  = '/var/lib/rioos'.freeze
    LOGHOME  = '/var/log/rioos'.freeze
    RUNHOME  = '/var/run/rioos'.freeze

    # STEP 2: Configure basic fields used across the packager
    # change the name to your own downstream fork.
    # eg:
    # origin: megam
    # product: Megam
    # product_prefix: megam
    BASIC = {
      origin:         'rioos',
      product:        'Rio/OS'.freeze,
      product_prefix: 'rioos'.freeze,
      version:        '2.0'.freeze,
      iteration:      '1'.freeze,
      license:        'MIT'.freeze,
      home:           HOME.to_s,
      libhome:        LIBHOME.to_s,
      loghome:        LOGHOME.to_s,
      runhome:        RUNHOME.to_s,
      vendor:         'RioAdvancement'.freeze,
      maintainer:     'RioAdvancement <dev@rio.company>'.freeze,
      registry_url:   'registry.rioos.xyz:5000'.freeze,
      url:            'https://docs.rioos.xyz'.freeze,
    }.freeze

    # *OPTIONAL*
    # STEP 3: Configure packages names to your choice
    COMMON      = BASIC[:product_prefix] + '-common'.freeze
    NILAVU      = BASIC[:product_prefix] + '-ui'.freeze
    MONITOR     = 'rio-metricsserver'.freeze
    ARAN        = BASIC[:product_prefix] + '-apiserver'.freeze
    MARKETPLACE = BASIC[:product_prefix] + '-marketplace'.freeze
    BLOCKCHAIN  = BASIC[:product_prefix] + '-blockchain'.freeze
    ARANCLI     = BASIC[:product_prefix] + '-cli'.freeze
    RIOOS       = BASIC[:product_prefix] + '-controller'.freeze
    PROMETHEUS  = BASIC[:product_prefix] + '-prometheus'.freeze
    NODELET     = BASIC[:product_prefix] + '-nodelet'.freeze
    STORLET     = BASIC[:product_prefix] + '-storlet'.freeze
    GULPD       = BASIC[:product_prefix] + '-gulp'.freeze
    VNC         = BASIC[:product_prefix] + '-vnc'.freeze
    NETWORK     = BASIC[:product_prefix] + '-network'.freeze
    FLUENTBIT   = BASIC[:product_prefix] + '-fluentbit'.freeze
    BOOTSTRAP   = BASIC[:product_prefix] + 'bootstrap'.freeze
    NODEJS      = BASIC[:product_prefix] + 'node'.freeze
  end
end
