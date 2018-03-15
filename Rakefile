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
    
    task :aventura => [:initship] do
        shipper = Pkg::DebsShipper.new(Pkg::Common.distro("aventura")).ship
    end 
   
    task :docker => [:initship] do
        shipper = Pkg::DockerShipper.new(Pkg::Common.distro("docker")).ship
    end    

    task :notify_published do
        #inform slack on build complete and refreshed. with url.
    end 

    task :all => [:aventura, :docker, :notify_published]

    end 
end
