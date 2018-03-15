require 'colorize'
require 'pkg/common'
require 'pkg/config'

module Pkg
  class DebsPublisher < BasePublisher
    attr_accessor :template


    NAME = "docker".freeze
    DOCKER = "docker".freeze

    def initialize(ship_paths)
      super(ship_paths)
    end


    def publish
      do_publish
    end

    private

    def ship_home
      @current_ship_path.ship_home
    end

    def ship_home_suffix(suffix)
      @current_ship_path.ship_home << '/' << suffix
    end

    def images_tarball
      Pkg::Util::File::files_with_ext(@current_ship_path.ship_home, 'tar.gz')
    end

    def docker_push(image)
      #sudo docker push <%= @basic[:registry_url]+"/rioosrethinkdb:"+@package[:version] %>
      DOCKER <<  ' -Vb ' << ship_home  <<  ' includedeb ' << @current_ship_path.distro << deb_file
    end

    def docker_tag(image)
      #sudo docker tag rio-rethinkdb <%= @basic[:registry_url]+"/rioosrethinkdb:"+@package[:version] %>
    end

    def do_publish(images)
      images.each do |image|
        Pkg::Util::Execution.ex(docker_push(image))
      end
    end

  end
end
