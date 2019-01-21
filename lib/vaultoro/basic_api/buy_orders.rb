module Vaultoro
  module BasicAPI
    class BuyOrders < Base
      attribute :list, Array[Order]

      def fetch
        @errors.clear

        response = Client.get('/buyorders', {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)
          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            hash['data'].each do |item|
              @list <<  BuyOrder.new(
                gold_amount: item['Gold_Amount'].to_f,
                gold_price: item['Gold_Price'].to_f
              )
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
