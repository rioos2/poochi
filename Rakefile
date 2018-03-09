require File.expand_path(File.join(File.dirname(__FILE__),'.', 'lib', 'pkg.rb'))

require 'pkg/shipper'

namespace :ship do

    task :default => :all

    task :clean do
        Pkg::Util::File.rmdir(Pkg::Config.ship_root)
    end

    task :initship do
        # Pkg::Util::File.mkdir_p(Pkg::Common.distro_build_dir)
    end

    task :looship => [:initship] do
        Pkg::Shipper.new(Pkg::Common.distro_dir).ship
    end

    task :xenial do
        Pkg::Common.distro("xenial")
        Rake::Task['ship:looship'].invoke
    end

    task :all => [:xenial]   do

    end
end
