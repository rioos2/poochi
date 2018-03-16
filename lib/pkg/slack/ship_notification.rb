require 'pkg/config'
require_relative 'webhook'

module Slack
  class ShipNotification < Webhook
    def self.webhook_url
      Pkg::Config.slack_ship_url
    end

    def self.release(distro)
      text = "☉ ‿ ⚆ > _#{Pkg::Config.slack_ship_bot}_ shipped [#{distro}] > `#{Pkg::Config.packaging_repo}/#{Pkg::Config.packaging_release}`"

      fire_hook(text: text)
    end
  end
end
