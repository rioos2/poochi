require 'colorize'
require 'pkg/common'
require 'pkg/config'

module Pkg
  class Shipper
    attr_accessor :distro

    def initialize(distro)
      @distro = distro
    end

    def ship_paths
      puts "=>    Ship: #{NAME} #{NAMED_REGEX}".colorize(:green).bold
      pather = Pkg::Util::File.install_files_into_dir(@distro, NAMED_REGEX, Pkg::Config.ship_root)
      puts "=> ✔  Ship: #{NAME} #{NAMED_REGEX}".colorize(:green).bold
      pather
    end

    def ship
      after_ship_paths_hook(ship_paths)
      after_ship
    end

    def after_ship_paths_hook(pather)
    end

    def self.NAME
      self::NAME
    end

    def self.NAMED_REGEX
      self::NAMED_REGEX
    end

    def os
      @distro.os
    end


  end
end
