module Vaultoro
  module BasicAPI
    class OrderBook < Base
      attribute :list, Array[Order]

      def fetch
        @errors.clear

        response = Client.get('/orderbook', {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)
          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            hash['data'].each do |orders|
              orders['b'] do |buy|
                @list << Order.new(
                  gold_amount: buy['Gold_Amount'].to_f,
                  gold_price: buy['Gold_Price'].to_f
                )
              end

              orders['s'] do |sell|
                @list << Order.new(
                  gold_amount: buy['Gold_Amount'].to_f,
                  gold_price: buy['Gold_Price'].to_f
                )
              end
            end
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
