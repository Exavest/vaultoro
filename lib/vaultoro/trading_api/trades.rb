module Vaultoro
  module TradingAPI
    class Trades < Base
      attribute :list, Array[Trade]
      attribute :since, DateTime
      attribute :count, Integer

      def fetch
        @errors.clear

        params = {}
        params.merge!(since: since.to_i) if since
        params.merge!(count: count.to_i) if count

        response = Client.get("/mytrades", params)
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)

          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            hash['data'].each do |trades|
              trades['b'] do |buy|
                @list << Trade.new(
                  side: 'BUY',
                  time: DateTime.parse(buy['Time']),
                  bitcoin_amount: buy['BTC_Amount'].to_f,
                  gold_amount: buy['Gold_Amount'].to_f,
                  gold_price: buy['Gold_Price'].to_f,
                  fee_amount: buy['GLDFee'].to_f,
                  fee_currency: 'GLD',
                  order_id: buy.fetch('Order_ID', nil)
                )
              end

              trades['s'] do |sell|
                @list << Trade.new(
                  side: 'SELL',
                  time: DateTime.parse(buy['Time']),
                  bitcoin_amount: buy['BTC_Amount'].to_f,
                  gold_amount: buy['Gold_Amount'].to_f,
                  gold_price: buy['Gold_Price'].to_f,
                  fee_amount: buy['BTCFee'].to_f,
                  fee_currency: 'BTC',
                  order_id: sell.fetch('Order_ID', nil)
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
