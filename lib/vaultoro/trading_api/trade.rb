module Vaultoro
  module TradingAPI
    class Trade
      include Virtus.model

      attribute :side, String
      attribute :time, Time
      attribute :bitcoin_amount, Float
      attribute :gold_amount, Float
      attribute :gold_price, Float
      attribute :fee_amount, Float
      attribute :fee_currency, String
      attribute :order_id, String
    end
  end
end
