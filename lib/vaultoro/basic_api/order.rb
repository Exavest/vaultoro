module Vaultoro
  module BasicAPI
    class Order
      include Virtus.model

      attribute :gold_amount, Float
      attribute :gold_price, Float
    end
  end
end
