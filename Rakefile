require File.expand_path(File.join(File.dirname(__FILE__), ".", "lib", "pkg.rb"))

require "pkg/shipper/debs"
require "pkg/shipper/rpms"
require "pkg/slack/ship_notification"

namespace :ship do
  task :default => :now

  task :clean do
    Pkg::Util::File.rmdir(Pkg::Config.ship_root)
  end

  task :initship do
    Pkg::Util::File.mkdir_p(Pkg::Config.ship_root)
  end

  task :notifyslack, [:distro] do |t, args|
    Slack::ShipNotification.release(args[:distro])
  end

  task :debs => [:initship] do
    shipper = Pkg::DebsShipper.new(Pkg::Common.distro("aventura"), Pkg::Common.distro_family_version_dir).ship
    Rake::Task["ship:notifyslack"].invoke("aventura")
  end

  task :rpms => [:initship] do
    shipper = Pkg::RpmsShipper.new(Pkg::Common.distro("centos"), Pkg::Common.distro_family_version_dir).ship
    Rake::Task["ship:notifyslack"].invoke("centos")
  end
end
