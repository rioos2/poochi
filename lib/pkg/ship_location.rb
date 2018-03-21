require 'pkg/config'

module Pkg
  class ShipLocation

    attr_accessor :os
    attr_accessor :ship_home
    attr_accessor :ship_dist_file
    attr_accessor :ship_distro_family_version

    CONF               = 'conf'
    DISTRIBUTION       = 'distributions'

    def initialize(os, distro_family_version_dir)
      @os          = os

      @ship_distro_family_version = distro_family_version_dir

      @ship_home    = Pkg::Config.ship_root << '/' << Pkg::Config.packaging_repo

      ensure_distribution_dir(ship_home + '/' +  CONF)

      @ship_dist_file = ship_home + '/'  + CONF + "/" + DISTRIBUTION
    end

    def dist
      return @ship_distro_family_version.split('/').first if @ship_distro_family_version.include?('/')

      @ship_distro_family_version
    end

    def version
      Pkg::Config.git_tag
    end

    def release
      Pkg::Config.packaging_repo
    end

    def gpg_key
      Pkg::Config.gpg_key
    end

    def deb_html_rooted_version_dir
          "" << dist << "/" << os << "/" << version << "/"  << release
    end

    private

    def ensure_distribution_dir(config)
      Pkg::Util::File.mkdir_p(config) unless Pkg::Util::File.exists?(config)
    end

  end
end
