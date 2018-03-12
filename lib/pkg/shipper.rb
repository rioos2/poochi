require 'colorize'
require 'pkg/common'
require 'pkg/config'

module Pkg
  class Shipper

    
    def ship
      puts "=> 4. Ship: *.deb, *.tar.gz".colorize(:green).bold      
      Pkg::Util::File.install_files_into_dir(['./**/*.deb', './**/*.tar.gz'], Pkg::Config.ship_root)
      puts "=> ✔  Ship: *.deb, *.tar.gz".colorize(:green).bold      
    end
  end
end
