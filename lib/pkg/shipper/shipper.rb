require 'colorize'
require 'pkg/common'
require 'pkg/config'

require_relative 'debs'

module Pkg
  class Shipper
    attr_accessor :distro

    def initialize(distro)
      @distro = distro
    end

    def ship_paths
      puts "=>    Ship: #{name} #{named_regex}".colorize(:green).bold
      pather = Pkg::Util::File.install_files_into_dir(@distro, named_regex, Pkg::Config.ship_root)
      puts "=> ✔  Ship: #{name} #{named_regex}".colorize(:green).bold
      pather
    end

    def ship
      ship_debs = ship_paths

      unless ship_debs.empty?
        after_ship_paths_hook(ship_debs)
        after_ship
      else
        puts "=> ✔  Ship: No #{name} found matching #{named_regex}".colorize(:magenta).bold
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
