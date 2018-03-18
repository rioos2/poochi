module Pkg::Params
  BUILD_PARAMS = %i[distro
                    name
                    project_root
                    packaging_repo
                    packaging_release
                    packaging_iteration
                    git_tag
                    gpg_key
                    ship_root
                    deb_html_root
                    docker_registry
                    enable_ship
                    slack_ship_url
                    slack_ship_bot].freeze



  def self.ARGVS
    return {} if ARGV.length <= 2

    cut_args = ARGV.slice(1..-1).map { |s| s.split('=') }.flatten

    Hash[*cut_args].map { |k, v| [k.to_sym, v] }.to_h
  end
end
