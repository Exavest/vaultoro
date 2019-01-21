module Vaultoro
  module TradingAPI
    class Buy < Base
      attribute :symbol, String, default: "gld" # Allowed value: "gld"
      attribute :type, String, default: "market" # Allowed values: "limit", "market"
      attribute :bitcoin, Float # Size range: 0.0002-100000 (expressed in bitcoin)
      attribute :gold, Float # Size range: 0.001-100000 (expressed in grams)
      attribute :price, Float # Size range: 0.00002-100000 (expressed in bitcoin, ignored for market orders)
      attribute :order_id, String
      attribute :order_time, Time # UTC

      def execute!
        ensure_attribute_has_value :symbol, :type

        @errors << ":bitcoin or :gold argument is required" unless @bitcoin || @gold
        @errors << ":symbol argument must be 'gold'" unless @symbol == 'gold'
        @errors << ":type argument must be 'limit' or 'market'" unless ['limit', 'market'].include?(@type)

        return false if @errors.any?

        params = {}
        params.merge!(btc: @bitcoin) if @bitcoin
        params.merge!(gld: @gold) if @gold
        params.merge!(price: @price) if @price && @type == 'market'

        response = Client.post("/buy/#{@symbol}/#{@type}", params)
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)

          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            @order_id = hash['data']['Order_ID']
            @order_time = DateTime.strptime(hash['data']['time'], '%Y-%m-%dT%H:%M:%S.%L%z').to_time.utc
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
