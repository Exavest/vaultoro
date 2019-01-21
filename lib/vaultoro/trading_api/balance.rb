module Vaultoro
  module TradingAPI
    class Balance
      include Virtus.model

      attribute :currency, String
      attribute :cash, Float
      attribute :reserved, Float
    end
  end
end
