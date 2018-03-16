require 'pkg/config'

module Slack
  class ShipNotification < Webhook
    def self.webhook_url
      Pkg::Config.slack_ship_url
    end

    def self.release(distro)
      text = "☉ ‿ ⚆ > _#{Pkg::Config.slack_ship_user}_ shipped [#{distro}] > `#{Pkg::Config.packaging_repo}/#{Pkg::Config.packaging_release}`"

      fire_hook(text: text)on
    end
  end
end
