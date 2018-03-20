module Pkg
  module Common
    attr_accessor :os

    ## All of these can be loaded using a YAMLLoader (build_data.yml)
    ## Default operation system supported
    SUPPORTED_OS = { os: %w[trusty xenial bionic aventura docker] }.freeze

    FAMILY_VERSIONS = { xenial:   { family: "ubuntu", version: "16.04" },
                        bionic:   { family: "ubuntu", version: "18.04" },
                        aventura: { family: "ubuntu", version: "2.0" },
                        docker:   { family: "ubuntu", version: "2.016.04" },
                      }.freeze

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

    def self.distro_family_version
      FAMILY_VERSIONS[@os]
    end

    def self.distro_family_version_dir
      distro_family_version[:family] + '/' + distro_family_version[:version]
    end

    def self.build_dir
      BUILD
    end

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
