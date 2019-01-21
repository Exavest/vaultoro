module Vaultoro
  module BasicAPI
    class LatestPrice < Base
      attribute :gold_price, Float

      def fetch
        @errors.clear

        response = Client.get('/latest', {})
        code = response.code rescue ""

        case code
        when '200'
          @status = 'SUCCESS'
          @gold_price = response.body.to_f

          return true
        else
          set_errors(response)
          return false
        end
      end
    end
  end
end
