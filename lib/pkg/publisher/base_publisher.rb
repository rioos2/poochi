
module Pkg
  class BasePublisher
    attr_accessor :ship_paths
    attr_accessor :current_ship_path

    NoShipperConfigurationError  = Class.new(StandardError)
    NoPublisherError  = Class.new(StandardError)

    def initialize(ship_paths)
      @ship_paths = ship_paths
      @current_ship_path = @ship_paths.first.value
    end

    def save
    end


    def generate
    end

    def publish
    end


    def self.NAME
      self::NAME
    end
  end
end
