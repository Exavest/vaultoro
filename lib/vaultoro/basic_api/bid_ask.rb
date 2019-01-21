module Vaultoro
  module BasicAPI
    class BidAsk < Base
      attribute :list, Array[PriceVolume]

      def fetch
        @errors.clear

        response = Client.get('/bidandask', {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)
          @status = 'SUCCESS'

          hash['bids'].each do |bid|
            @list << PriceVolume.new(type: 'bid', price: bid[0].to_f, volume: bid[1].to_f)
          end

          hash['asks'].each do |ask|
            @list << PriceVolume.new(type: 'ask', price: bid[0].to_f, volume: bid[1].to_f)
          end

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
