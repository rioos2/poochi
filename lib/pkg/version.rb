require 'pkg/config'

module Pkg
  module Version  

    ### Please configure (STEPS BASIC, 1, 2, 3) to whitelable builds
    # BASIC: Configure the tool versions to use
    # golang: go version  | grep 1.10 > /dev/null
    # node: node version | grep 9.7 > /dev/null
    COMPILE = {
      golang:  {cmd: 'go version  | grep 1.10 > /dev/null', link: "Installing https://golang.org/dl"},
      node:    {cmd: 'node -v | grep 9.8 > /dev/null', link: "Installing https://nodejs.org/en/"},
      yarn:    {cmd: 'yarn -v | grep 1.5 > /dev/null', link: "Installing http://bit.ly/gitpyarni"},
      rustc:   {cmd: 'rustc -V | grep 1.24.1 > /dev/null', link: "Installing http://bit.ly/gitprustci"},
      docker:  {cmd: 'docker -v | grep 18 > /dev/null', link: "Uninstalling http://bit.ly/gitpdocku, Installing: http://bit.ly/gitpdocki" }
    }.freeze


    # Publish: Configure the tool versions to use for publishing debs
    # reprepro: reprepro version  | grep 1.10 > /dev/null
    # node: node version | grep 9.7 > /dev/null
    DEBSPUBLISH = {
      reprepro:    {cmd: 'reprepro -v | grep 1.5 > /dev/null', link: "Installing http://bit.ly/gitppublish"},
      nginx:   {cmd: 'nginx -V | grep 1.24.1 > /dev/null', link: "Installing http://bit.ly/gitppublish"},
    }.freeze

    ## check if  required compile tools are installed
    #Pkg::Tools.new.check?(COMPILE)

    ## check if  required publish  tools are installed, if configured for debs
    ##
    #Pkg::Tools.new.check?(DEBSPUBLISH) unless Pkg::Config.enable_ship

    ## All of these can be loaded using a YAMLLoader (build_data.yml)
    ## Default operation system supported
    SUPPORTED_OS = { os: %w[aventura docker] }.freeze

    ## STEP 1: Configure directories
    # change the name to your own downstream fork.
    # eg:
    # HOME    = "/usr/share/rioos"
    # LIBHOME = "/var/lib/rioos"
    # LOGHOME = "/var/log/rioos"
    # RUNHOME = "/var/run/rioos"
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
      home:           HOME.to_s,
      libhome:        LIBHOME.to_s,
      loghome:        LOGHOME.to_s,
      runhome:        RUNHOME.to_s,
      vendor:         'Rio Advancement Inc'.freeze,
      maintainer:     'Rio Advancement Inc <dev@rio.company>'.freeze,
      registry_url:   Pkg::Config.docker_registry,
      url:            'https://docs.rioos.xyz'.freeze,
      version: Pkg::Config::git_tag,
      iteration: Pkg::Config::pp
    }

    # *OPTIONAL*
    # STEP 3: Configure packages names to your choice
    COMMON      = BASIC[:product_prefix] + '_common'.freeze
    NILAVU      = BASIC[:product_prefix] + '_ui'.freeze
    ARAN        = BASIC[:product_prefix] + '_api'.freeze
    BLOCKCHAIN  = BASIC[:product_prefix] + '_blockchain'.freeze
    MARKETPLACE = BASIC[:product_prefix] + '_marketplace'.freeze
    ARANCLI     = BASIC[:product_prefix] + '_cli'.freeze
    CONTROLLER  = BASIC[:product_prefix] + '_controller'.freeze
    NODELET     = BASIC[:product_prefix] + '_nodelet'.freeze
    STORLET     = BASIC[:product_prefix] + '_storlet'.freeze
    GULPD       = BASIC[:product_prefix] + '_gulp'.freeze
    VNC         = BASIC[:product_prefix] + '_vnc'.freeze
    NETWORK     = BASIC[:product_prefix] + '_network'.freeze
    FLUENTBIT   = BASIC[:product_prefix] + '_fluentbit'.freeze
    PROMETHEUS  = BASIC[:product_prefix] + '_prometheus'.freeze
    BOOTSTRAP   = BASIC[:product_prefix] + '_bootstrap'.freeze


  end
end
