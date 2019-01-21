module Vaultoro
  module BasicAPI
    class Transactions < Base
      attribute :time, String # Allowed values: "hour", "day", "month"
      attribute :list, Array[Transaction]

      def fetch
        @errors.clear

        ensure_attribute_has_value :time

        @errors << ":time argument must be either 'hour', 'day' or 'month'" unless ["hour", "day", "month"].include?(@time)

        return false if @errors.any?

        response = Client.get("/transactions/#{@time}", {})
        code = response.code rescue ""

        case code
        when '200'
          hash = JSON.parse(response.body)
          @status = hash['status'].upcase

          if @status == 'SUCCESS'
            hash['data'].each do |transaction|
              @list << Transaction.new(
                time: DateTime.strptime(transaction['Time'], '%Y-%m-%dT%H:%M:%S.%L%z').to_time.utc,
                gold_price: transaction['Gold_Price'].to_f,
                gold_amount: transaction['Gold_Amount'].to_f
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
