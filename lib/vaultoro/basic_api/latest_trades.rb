module Vaultoro
  module BasicAPI
    class LatestTrades < Base
      attribute :since, Integer # Transaction Identifier
      attribute :count, Integer # Size range: 1-250
      attribute :list, Array[Trade]

      def fetch
        @errors.clear
        @errors << ":since or :count argument is required" unless @since || @count
        @errors << ":count argument must be between 1-250" unless @count && @count >= 1 && @count <= 250

        return false if @errors.any?

        params = {}
        params.merge!(since: @since) if @since
        params.merge!(count: @count) if @count

        response = Client.get("/latesttrades", params)
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)
          @status = 'SUCCESS'

          hash.each do |trade|
            @list << Trade.new(
              transaction_id: trade['tid'],
              price: trade['price'].to_f,
              amount: trade['amount'].to_f,
              time: DateTime.strptime(trade['date'], '%Y-%m-%dT%H:%M:%S.%L%z').to_time.utc
            )
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
