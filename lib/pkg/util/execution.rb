require 'colorize'

module Pkg::Util::Execution
  class << self
      def success?(statusobject = $CHILD_STATUS)
        statusobject.success?
      end

      def ex(command, debug = false)
        puts "   ✔ exec #{command}".colorize(:blue).bold if debug
        ret = `#{command}`
        raise RuntimeError unless Pkg::Util::Execution.success?

        if debug
          puts "   ✔ exec returned \n#{ret}".colorize(:blue).bold if debug
        end

        ret
      end

      def retry_on_fail(args)
        success = FALSE

        if args[:times].respond_to?(:times) && block_given?
          args[:times].times do |_i|
            sleep args[:delay] if args[:delay]

            begin
              yield
              success = TRUE
              break
            rescue
              puts '   ✘ An error was encountered evaluating block. Retrying..'.colorize(:red)
            end
          end
        else
          raise 'retry_on_fail requires and arg (:times => x) where x is an Integer/Fixnum, and a block to execute'
        end
        raise "Block failed maximum of #{args[:times]} tries. Exiting.." unless success
      end
  end
end
