module Pkg
  ## check if  colorize gem is installed.
  unless Gem::Specification.find_all_by_name('colorize').any?
     puts '   ✘ gem colorize not installed'
     puts 'Run "`bundle install` from `poochi`"'
    exit
  end

  LIBDIR = File.expand_path(File.dirname(__FILE__))

  $LOAD_PATH.unshift(LIBDIR) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) || $LOAD_PATH.include?(LIBDIR)

  require 'rake'
  require 'colorize'

  require 'pkg/common'
  require 'pkg/version'
  require 'pkg/util'

  require 'pkg/cloner'
  require 'pkg/builder'
  require 'pkg/config'
  require 'pkg/static/data'

  require 'pkg/scripter'
  require 'pkg/yaml_builder'
  require 'pkg/ship_location'
  require 'pkg/shipper/debs'
  require 'pkg/shipper/shipper'
  require 'pkg/publisher/debs'
  require 'pkg/publisher/base_publisher'
  require 'pkg/tools'

  # Load configuration defaults
  Pkg::YamlBuilder.new.save
  Pkg::Config.load_defaults
  Pkg::Config.load_default_configs
end
