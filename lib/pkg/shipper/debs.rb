require 'colorize'
require 'pkg/common'
require 'pkg/config'
require 'pkg/publisher'

module Pkg
  class DebsShipper < Shipper

    NAME = "debs".freeze
    NAMED_REGEX = ['./**/#{os}/**/*.deb'].freeze

    def initialize(distro)
      super(distro)
    end

    def after_ship_paths_hook(ship_pather)
      generate_and_publish(ship_pather)   
    end    

    def after_ship
      puts "=> ✔  Ship: configuration".colorize(:green).bold
    end

    private

    def  generate_and_publish(ship_pather)
      publisher = Pkg::DebsPublisher::new(ship_pather)
      publisher.save
      publisher.generate
      publisher.publish
    end
  end
end
