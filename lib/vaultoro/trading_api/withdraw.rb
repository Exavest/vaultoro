module Vaultoro
  module TradingAPI
    class Withdraw < Base
      attribute :bitcoin, Float # Size range: 0.00010001-100000
      attribute :address, String

      def execute!
        ensure_attribute_has_value :btc
        return false if @errors.any?

        params = { btc: @bitcoin }

        response = Client.post("/withdraw", params)
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)

          @status = hash['status'].upcase
          @address = hash['data']['address']

          unless @status == 'SUCCESS'
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
