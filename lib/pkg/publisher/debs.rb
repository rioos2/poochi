require 'colorize'
require 'pkg/common'
require 'pkg/config'

require_relative 'base_publisher'

module Pkg
  class DebsPublisher < BasePublisher
    attr_accessor :template

    NAME = "deb"
    REPREPRO = "reprepro"

    def initialize(ship_paths)
      super(ship_paths)

      distribute_erb     = NAME << ".distribution.erb"

      erb_path = Pathname(File.expand_path(File.dirname(__FILE__))).to_s << "/../../../" << distribute_erb

      @out_path  = @current_ship_path.ship_dist_file

      @template = IO.read(erb_path)
    end

    def render
      ERB.new(@template).result(binding)
    end

    ## Write a reprepro distribution from the reprepro.distribution.erb
    def save
      puts "=> 5. Write #{@out_path}".colorize(:green).bold
      FileUtils.rm(@out_path) if Pkg::Util::File.exists?(@out_path)

      File.open(@out_path, 'w+') do |f|
        puts "   ✔ #{f.path}".colorize(:blue)
        f.write(render)
      end
    end

    def exists?
      true
    end


    def generate
      do_generate(deb_files)
      puts "   ✔  reprepro: *.deb".colorize(:blue).bold
    end

    def publish
      do_publish
      set_permission
    end

    private

    def ship_home
      @current_ship_path.ship_home
    end

    def deb_html_root_full
      File.join(Pkg::Config.deb_html_root, @current_ship_path.deb_html_rooted_version_dir)
    end

    def ship_home_suffix(suffix)
     @current_ship_path.ship_home +  '/' +  suffix
    end

    def deb_files
      Pkg::Util::File::files_with_ext(@current_ship_path.ship_home, 'deb')
    end

    def reprepro(deb_file )
      tmp = "  " <<  '--ask-passphrase  -Vb ' << ship_home  <<  ' includedeb ' << @current_ship_path.os << " "  << deb_file
      REPREPRO + tmp
    end

    def do_generate(deb_files)
      deb_files.each do |deb_file|
        Pkg::Util::Execution.ex(reprepro(deb_file))
      end
    end

    def do_publish
      %w[db dists pool].each do |suffix|
        ship_home_suffixed = ship_home_suffix(suffix)
        unless !Pkg::Util::File::directory?(ship_home_suffixed)
          Pkg::Util::File::mkdir_p(deb_html_root_full)
          Pkg::Util::File::cp_r(ship_home_suffixed, deb_html_root_full)
          Pkg::Util::File::rmdir(ship_home_suffixed)
        end
      end
    end

    def set_permission
      ### What the hect is the build directory
      #Pkg::Util::Execution::ex("chmod -R ugo+rX $BUILD_dir")
    end

  end
end
