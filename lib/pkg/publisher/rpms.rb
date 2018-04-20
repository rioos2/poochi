require "colorize"
require "pkg/common"
require "pkg/config"

require_relative "base_publisher"

module Pkg
  class RpmsPublisher < BasePublisher
    NAME = "rpm"
    CREATEREPO = "createrepo"

    def initialize(ship_paths)
      super(ship_paths)
    end

    def exists?
      true
    end

    def generate
      do_generate(deb_files)
      puts "   ✔  createrepo: *.rpm".colorize(:blue).bold
    end

    def publish
      do_publish
      set_permission
    end

    private

    def ship_home
      @current_ship_path.ship_home
    end

    def rpm_html_root_full
      File.join(Pkg::Config.deb_html_root, @current_ship_path.rpm_html_rooted_version_dir)
    end

    def ship_home_suffix(suffix)
      @current_ship_path.ship_home + "/" + suffix
    end

    def rpm_files
      Pkg::Util::File::files_with_ext(@current_ship_path.ship_home, "rpm")
    end

    def createrepo
      tmp = "  " << ship_home << @current_ship_path.os
      CREATEREPO + tmp
    end

    def do_generate(deb_files)
      Pkg::Util::Execution.ex(createrepo)
    end

    def do_publish
      Pkg::Util::File::mkdir_p(rpm_html_root_full)
      Pkg::Util::File::cp_r(ship_home, rpm_html_root_full)
    end

    def set_permission
      ### What the hect is the build directory
      #Pkg::Util::Execution::ex("chmod -R ugo+rX $BUILD_dir")
    end
  end
end
