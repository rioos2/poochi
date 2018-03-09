module Pkg
  module Common
    attr_accessor :os

    ## All of these can be loaded using a YAMLLoader (build_data.yml)
    ## Default operation system supported
    SUPPORTED_OS = { os: %w[trusty xenial centos7 docker] }.freeze

    ### The build directory
    BUILD = 'build'.freeze

  #  PACKAGE_NAME = 'rioos_bootstrap'.freeze

    # set the ditro and the distro build directory if its the supported os.
    def self.distro(os)
      @os = os
    end

    def self.distro_dir
      @os
    end

    def self.build_dir
      BUILD
    end

  #  def self.package_name
  #    PACKAGE_NAME
  #  end

    def self.distro_build_dir
      (BUILD + '/' + distro_dir) if supported_os?
    end

    private

    def self.supported_os?
      raise "=> Unsupported OS: #{@os}" unless SUPPORTED_OS[:os].include? @os
      true
    end
  end
end
