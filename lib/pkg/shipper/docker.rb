require 'colorize'
require 'pkg/common'
require 'pkg/config'

module Pkg
  class DockerShipper < Shipper
    attr_accessor :distro

    NAME = "docker".freeze
    NAMED_REGEX = ['./**/#{os}/**/*.tar.gz'].freeze

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
      publisher = Pkg::DockerPublisher::new(ship_pather)
      publisher.save
      publisher.generate
      publisher.publish
    end
  end
end
