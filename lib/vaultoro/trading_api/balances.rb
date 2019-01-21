module Vaultoro
  module TradingAPI
    class Balances < Base
      attribute :list, Array[Balance]

      def fetch
        @errors.clear

        response = Client.get("/balance", {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)

          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            hash['data'].each do |balance|
              @list << Balance.new(
                :currency => balance['currency_code'],
                :cash => balance['cash'].to_f,
                :reserved => balance['reserved'].to_f
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
