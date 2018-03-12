require 'erb'
require 'colorize'
require 'pathname'

module Pkg
  class YamlBuilder
    include ERB::Util

    class CouldNotFindVERSIONFileError <  StandardError
      def initialize(path) 
        super(path)
      end
    end

    NilIterationError = Class.new(StandardError)
    EmptyVersion = Class.new(StandardError)
    
      
    attr_accessor :basic
    attr_accessor :package
    attr_accessor :date
    attr_accessor :template
    attr_accessor :out_path

    def initialize
      @basic = ''
      @package  = ''
      @date     = ''
      @otta     = ensure_ottavada_was_run

      erb_path = Pathname(File.expand_path(File.dirname(__FILE__))).to_s + '/../../build_defaults.yaml.erb'

      @out_path = Pathname(File.expand_path(File.dirname(__FILE__))).to_s + '/../../build_defaults.yaml'

      @template = IO.read(erb_path)
    end

    def render
      ERB.new(@template).result(binding)
    end

    def save
      FileUtils.rm(@out_path) if Pkg::Util::File.exists?(@out_path)

      File.open(@out_path, 'w+') do |f|
        puts "   ✔ #{f.path}".colorize(:blue)
        f.write(render)
      end
    end

    private
    
    def  ensure_ottavada_was_run
      version_path = Pathname(File.expand_path(File.dirname(__FILE__))).to_s + '/../../VERSION'
      
      raise CouldNotFindVERSIONFileError::new(version_path) unless Pkg::Util::File.exists?(version_path)

      return parse_version(IO.read(version_path))
    end 

    def parse_version(version)
      raise EmptyVersion if version.empty?

      iteration =  version.strip.chars.pop

      raise NilIterationError  unless !!Integer(iteration)

      { version: version.strip, 
        iteration: (iteration.to_i < 0 ? '0': iteration), 
        which_repo: (not_stable?(version) ? 'testing' : 'stable')
      }
    end 

    def not_stable?(version) 
      ['rc', 'pre', 'beta', 'alpha'].select{|x| version.include?(x)}.length > 0
    end
  end
end
