module Vaultoro
  module BasicAPI
    class Trade
      include Virtus.model

      attribute :transaction_id, Integer
      attribute :price, Float
      attribute :amount, Float
      attribute :time, Time
    end
  end
end
