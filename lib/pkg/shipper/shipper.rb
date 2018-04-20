require "colorize"
require "pkg/common"
require "pkg/config"

require_relative "debs"
require_relative "rpms"

module Pkg
  class Shipper
    attr_accessor :os
    attr_accessor :distro_family

    def initialize(os, distro_family)
      @os = os
      @distro_family = distro_family
    end

    def ship_paths
      pather = Pkg::Util::File.install_files_into_dir(@os, @distro_family, named_regex, Pkg::Config.ship_root)
      puts "=> ✔  Ship: #{name} #{named_regex}".colorize(:green).bold
      pather
    end

    def ship
      puts "=> Ship: [ship: aventura:]".colorize(:cyan).bold
      puts "=> 4. Ship: #{name} #{named_regex}".colorize(:green).bold
      ship_artifacts = ship_paths

      unless ship_artifacts.empty?
        after_ship_paths_hook(ship_artifacts)
        after_ship
      else
        puts "   ✘ skip ship - no #{name} found matching #{named_regex}".colorize(:red)
      end
    end

    # Overridable
    def after_ship_paths_hook(pather)
      raise NotImplementedError
    end

    # Overridable
    def name
      raise NotImplementedError
    end

    # Overridable
    def named_regex
      raise NotImplementedError
    end
  end
end
