require File.expand_path(File.join(File.dirname(__FILE__),'.', 'lib', 'pkg.rb'))

require 'pkg/shipper'


namespace :ship do

    task :default => :now

    task :clean do
        Pkg::Util::File.rmdir(Pkg::Config.ship_root)
    end

    task :initship do
        Pkg::Util::File.mkdir_p(Pkg::Config.ship_root)
    end

    task :now => [:initship] do
        Pkg::Shipper.new.ship
    end    
end
