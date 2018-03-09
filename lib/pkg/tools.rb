require 'fileutils'
require 'colorize'

module Pkg
    class Tools

        ## check if the following build tools are installed
        ## 2.0 [git, ruby, golang, npm, cargo]
        def check?(cmds)
            cmds.each do |k, v|    
                unless is_there?(v[:cmd])
                    puts "   ✘ #{v[:cmd]} failed"
                    puts "   » Refer instruction for \n #{v[:link]}"
                    exit
                end
            end
        end

        private

        def is_there?(cmd)
            system cmd; result =$?.success?
        end

    end
end
