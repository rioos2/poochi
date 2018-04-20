require "colorize"
require "pkg/common"
require "pkg/config"

require "pkg/publisher/debs"
require_relative "shipper"

module Pkg
  class RpmsShipper < Pkg::Shipper
    NAME = "rpms".freeze

    def after_ship_paths_hook(ship_pather)
      unless ship_pather.empty?
        generate_and_publish(ship_pather)
      end
    end

    def after_ship
      puts "   ✔  Ship: configuration".colorize(:green).bold
    end

    def name
      NAME
    end

    def named_regex
      ["**/**/" << @os << "/*.rpm"]
    end

    private

    def generate_and_publish(ship_pather)
      publisher = Pkg::RpmsPublisher::new(ship_pather)
      publisher.save
      publisher.generate
      publisher.publish
    end
  end
end
