require 'fileutils'
require 'colorize'
require 'pathname'

module Pkg::Util::File
  class << self
    def exist?(file)
      ::File.exist?(file)
    end

    ## just a wrapper, with colored printing, equivalent to shell mkdir -p
    def mkdir_p(dir)
      FileUtils.mkdir_p dir
      puts "   ✔ mkdir -p #{dir}".colorize(:blue).bold
    end

    ## just a wrapper, with colored printing, equivalent to shell rmrf
    def rmdir(dir)
      FileUtils.rm_rf dir
      puts "   ✔ rm -rf #{dir}".colorize(:magenta).bold
    end

    alias exists? exist?

    def directory?(file)
      ::File.directory?(file)
    end

    def mktemp
      mktemp = Pkg::Util::Tool.find_tool('mktemp', required: true)
      Pkg::Util::Execution.ex("#{mktemp} -d -t pkgXXXXXX").strip
    end

    def empty_dir?(dir)
      File.exist?(dir) && File.directory?(dir) && Dir["#{dir}/**/*"].empty?
    end

    def directories(dir)
      if File.directory?(dir)
        Dir.chdir(dir) do
          Dir.glob('*').select { |entry| File.directory?(entry) }
        end
      end
    end

    def files_with_ext(dir, ext)
      Dir.glob("#{dir}/**/*#{ext}")
    end

    def file_exists?(file, args = { required: false })
      exists = File.exist? file
      if !exists && args[:required]
        raise "Required file #{file} could not be found"
      end
      exists
    end

    def file_writable?(file, args = { required: false })
      writable = File.writable? file
      raise "File #{file} is not writable" if !writable && args[:required]
      writable
    end

    alias get_temp mktemp

    def erb_string(erbfile, b = binding)
      template = File.read(erbfile)
      message  = ERB.new(template, nil, '-')
      message.result(b)
    end

    def erb_file(erbfile, outfile = nil, remove_orig = false, opts = { binding: binding })
      outfile ||= File.join(mktemp, File.basename(erbfile).sub(File.extname(erbfile), ''))
      output = erb_string(erbfile, opts[:binding])
      File.open(outfile, 'w') { |f| f.write output }
      puts "Generated: #{outfile}"
      FileUtils.rm_rf erbfile if remove_orig
      outfile
    end

    def install_files_into_dir(file_patterns, workdir)
      install = []
      Dir.chdir(Pkg::Config.project_root) do
        file_patterns.each do |pattern|
          install << if File.directory?(pattern) && !Pkg::Util::File.empty_dir?(pattern)
                       Dir[pattern + '/**/*']
                     else
                       Dir[pattern]
                     end
        end
        install.flatten!

        install = install.select { |x| File.file?(x) || File.symlink?(x) || Pkg::Util::File.empty_dir?(x) }

        install.each do |file|
          if Pkg::Util::File.empty_dir?(file)
            FileUtils.mkpath(File.join(workdir, file), verbose: false)
          else
            ship_path = File.join(Pkg::Config.packaging_repo,
                                  Pkg::Config.git_release,
                                  Pathname.new(file).relative_path_from(Pathname.new(file).dirname.parent))

            FileUtils.mkpath(File.dirname(File.join(workdir, ship_path)), verbose: false)
            FileUtils.cp(file, File.join(workdir, ship_path), verbose: false, preserve: true)
          end
          puts "   ✔ shipping #{File.join(workdir, ship_path)}".colorize(:blue)
        end
      end
    end
  end
end
