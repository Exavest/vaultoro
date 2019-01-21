module Vaultoro
  module Trading
    class TradingAPI
      include Virtus.model

      attribute :side, String
      attribute :bitcoin_amount, Float
      attribute :gold_amount, Float
      attribute :gold_price, Float
      attribute :order_id, String
    end
  end
end
