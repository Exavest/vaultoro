module Vaultoro
  module BasicAPI
    class Transaction
      include Virtus.model

      attribute :time, Time
      attribute :gold_amount, Float
      attribute :gold_price, Float
    end
  end
end
