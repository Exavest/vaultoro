module Vaultoro
  module TradingAPI
    class Cancel < Base
      attribute :order_id, String

      def execute!
        ensure_attribute_has_value :order_id
        return false if @errors.any?

        response = Client.post("/cancel/#{@order_id}", {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)

          @status = hash['status'].upcase
          @order_id = hash['data']['Order_ID']

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
