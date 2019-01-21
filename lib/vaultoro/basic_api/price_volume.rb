module Vaultoro
  module BasicAPI
    class PriceVolume
      include Virtus.model

      attribute :type, String # Either 'bid' or 'ask'
      attribute :price, Float
      attribute :volume, Float
    end
  end
end
