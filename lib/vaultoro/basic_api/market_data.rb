module Vaultoro
  module BasicAPI
    class MarketData < Base
      attribute :market_currency, String
      attribute :base_currency, String
      attribute :market_currency_name, String
      attribute :base_currency_name, String
      attribute :min_trade_size, Float
      attribute :market_name, String
      attribute :is_active, Boolean
      attribute :min_unit_qty, Float
      attribute :min_price, Float
      attribute :last_price, Float
      attribute :daily_low, Float
      attribute :daily_high, Float
      attribute :daily_volume, Float

      def fetch
        @errors.clear

        response = Client.get('/markets', {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)
          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            @market_currency = hash['data']['MarketCurrency']
            @base_currency = hash['data']['BaseCurrency']
            @market_currency_name = hash['data']['MarketCurrencyLong']
            @base_currency_name = hash['data']['BaseCurrencyLong']
            @min_trade_size = ("%f" % "#{hash['data']['MinTradeSize']}").to_f
            @market_name = hash['data']['MarketName']
            @is_active = hash['data']['IsActive']
            @min_unit_qty = hash['data']['MinUnitQty'].to_f
            @min_price = hash['data']['MinPrice'].to_f
            @last_price = hash['data']['LastPrice'].to_f
            @daily_low = hash['data']['24hLow'].to_f
            @daily_high = hash['data']['24hHigh'].to_f
            @daily_volume = hash['data']['24HVolume'].to_f
          else
            set_errors(response)
            return false
          end

          return true
        else
          set_errors(response)
          return false
        end
      end
    end
  end
end
