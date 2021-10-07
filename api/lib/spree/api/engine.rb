require 'rails/engine'

module Spree
  module Api
    class Engine < Rails::Engine
      isolate_namespace Spree
      engine_name 'spree_api'

      initializer 'spree.api.environment', before: :load_config_initializers do |_app|
        Spree::Api::Config = Spree::ApiConfiguration.new
        Spree::Api::Dependencies = Spree::ApiDependencies.new
      end

      initializer 'spree.api.checking_migrations' do
        Migrations.new(config, engine_name).check
      end

      initializer 'spree.api.checking_deprecated_preferences' do
        Spree::Api::Config.deprecated_preferences.each do |pref|
          # FIXME: we should only notify about deprecated preferences that are in use, not all of them
          # warn "[DEPRECATION] Spree::Api::Config[:#{pref[:name]}] is deprecated. #{pref[:message]}"
        end
      end

      initializer 'Spree::Webhooks' do
        ActiveSupport.on_load(:spree_base) do
          include Spree::Webhooks::HasWebhooks
        end

        ActiveSupport.on_load(:spree_order) do
          prepend Spree::Api::Webhooks::Order
        end

        ActiveSupport.on_load(:spree_payment) do
          prepend Spree::Api::Webhooks::Payment
        end

        ActiveSupport.on_load(:spree_shipment) do
          prepend Spree::Api::Webhooks::Shipment
        end
      end

      def self.root
        @root ||= Pathname.new(File.expand_path('../../..', __dir__))
      end
    end
  end
end
