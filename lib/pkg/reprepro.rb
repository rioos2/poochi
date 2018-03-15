require 'colorize'
require 'pkg/common'
require 'pkg/config'

module Pkg
  class RepRepro
    attr_accessor :ship_pather
    attr_accessor :tempate

    NAME = "reprepro".freeze

    def initialize(ship_pathers)
      distribute_erb     = NAME + ".distribution.erb"

      erb_path = Pathname(File.expand_path(File.dirname(__FILE__))).to_s + '/../../#{distribute_erb}'

      @out_path = ship_pather.first.value.config_file

      @template = IO.read(erb_path)
    end

    def render
      ERB.new(@template).result(binding)
    end

    ## Write a reprepro distribution from the reprepro.distribution.erb
    def save
      puts "=> Write #{pkgcommon.os} #{@template}".colorize(:green).bold
      FileUtils.rm(@out_path) if Pkg::Util::File.exists?(@out_path)

      File.open(@out_path, 'w+') do |f|
        puts "   ✔ #{f.path}".colorize(:blue)
        f.write(render)
      end
    end

    ## Check is the reprepro exists.
    ## We only do it here, since only shippers rake tasks need it.
    def exists?

    end


    def generate
      return RepReproNotFound unless exists?
      do_generate()

      puts "=> ✔  Reprepro: *.deb, *.tar.gz".colorize(:green).bold
    end

    def publish
      do_publish
    end

    private

    def do_generate

      #find $DEB_DIR -name \*.deb -exec reprepro --ask-passphrase -Vb $PACKAGE_ROUTE_DIR includedeb $distroname {} \;
    end

    def do_publish
      #cp -R  $PACKAGE_ROUTE_DIR/db $REPO_ROUTE_DIR && rm -R $PACKAGE_ROUTE_DIR/db
      #cp -R $PACKAGE_ROUTE_DIR/dists $REPO_ROUTE_DIR && rm -R $PACKAGE_ROUTE_DIR/dists
      #cp -R  $PACKAGE_ROUTE_DIR/pool $REPO_ROUTE_DIR && rm -R $PACKAGE_ROUTE_DIR/pool
      #chmod -R ugo+rX $BUILD_dir
    end

  end
end
