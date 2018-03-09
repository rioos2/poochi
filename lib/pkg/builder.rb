require 'rake'
require 'fileutils'
require 'colorize'
require 'pkg/scripter' # As this is called from one level down from Rakefile we do ../

module Pkg
  class Builder
    attr_accessor :distro_dir
    attr_accessor :distro_build_dir
    attr_accessor :date, :package
    attr_accessor :package_name

    def initialize(distro_dir, distro_build_dir, package, date = Time.now)
      @distro_dir = distro_dir
      @distro_build_dir = distro_build_dir
      @package = package
      @date = date
    end

    def exec
      make
      clone
      run
    end

    private

    def make(ls_dir = @distro_dir)
      puts "=> 1. Transform: erb - #{ls_dir} #{@distro_build_dir} ".colorize(:green).bold
      if File.exist?(@distro_dir)
        Rake::FileList[ls_dir + '/**'].each do |f|
          if File.file?(f)
            @scripter = Scripter.new(Pkg::Version::BASIC, @package, IO.read(f))
            @scripter.save(File.join(distro_build_dir.to_s, File.basename(f, '.erb')))
          else
            if @distro_dir == 'trusty'
              Pkg::Util::File.mkdir_p(distro_build_dir.to_s + '/etc/init/')
              Rake::FileList["#{f}/init/**"].each do |d|
                @scripter = Scripter.new(Pkg::Version::BASIC, @package, IO.read(d))
                @scripter.save(File.join(distro_build_dir.to_s + '/etc/init/', File.basename(d, '.erb')))
              end
            else
              Pkg::Util::File.mkdir_p(distro_build_dir.to_s + '/etc/systemd/system/')
              Rake::FileList["#{f}/systemd/system/**"].each do |d|
                @scripter = Scripter.new(Pkg::Version::BASIC, @package, IO.read(d))
                @scripter.save(File.join(distro_build_dir.to_s + '/etc/systemd/system/', File.basename(d, '.erb')))
              end
            end
          end
        end
      end
      Dir.chdir @distro_build_dir
    end

    def clone
      Cloner.new(@package).clone
    end

    def run
      puts "=> 3. Execute: g - #{@distro_dir}".colorize(:green).bold
      if File.file?('./g')
        FileUtils.chmod 0o755, './g'
        system './g'
      else
        puts "   ✘ skip g - #{@distro_dir}".colorize(:red)
      end
    end
  end
end
