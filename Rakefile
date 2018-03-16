require File.expand_path(File.join(File.dirname(__FILE__),'.', 'lib', 'pkg.rb'))

require 'pkg/shipper'
require 'pkg/slack'


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
    Rake::Task[:notify_slack].invoke("aventura")
  end  

  task :notify_slack, [:distro] do |t, args|
    Slack::ShipNotification.release(args[:distro])
  end

  task :all => [:aventura, :notify_slack] do
    Rake::Task[:notify_slack].invoke("[aventura]")
  end
end