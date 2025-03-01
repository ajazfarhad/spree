module Spree
  module Api
    module Webhooks
      module StockMovementDecorator
        def update_stock_item_quantity
          variant_in_stock_before_update = variant_in_stock?
          super
          variant = stock_item.variant
          variant.queue_webhooks_requests!('variant.out_of_stock') if variant_in_stock_before_update && !variant_in_stock?
        end

        private

        def variant_in_stock?
          stock_item.variant.in_stock?
        end
      end
    end
  end
end

Spree::StockMovement.prepend(Spree::Api::Webhooks::StockMovementDecorator)
