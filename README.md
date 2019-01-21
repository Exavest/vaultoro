[![Gem Version](https://badge.fury.io/rb/vaultoro.svg)](https://badge.fury.io/rb/vaultoro)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/exavest/vaultoro/pulls)

# Vaultoro

A ruby API client for [vaultoro.com](https://vaultoro.com/?a=109382), a global bitcoin and physical gold exchange that runs 24 hours a day, every day of the year. [Vaultoro](https://vaultoro.com/?a=109382) facilitates the purchase of real 99.9% pure gold using bitcoin. [Vaultoro](https://vaultoro.com/?a=109382) gold is stored in a high security vaulting facility operated by ProAurum AG in Switzerland, the largest precious metals dealer in Europe. All gold is 100% allocated, reserved and secured under your name as your property and all holdings are audited by one of the largest auditing firms in the world - BDO International. In addition every gram of gold is professionally insured against physical loss for full replacement value. All transactions are instantly settled, and publicly audit-able via the Glass Books Protocol.

This ruby gem is currently being used by [Exavest](https://exavest.com) to provide an additional portfolio facet. You can be assured the API will remain consistent and stable should you choose to utilize it yourself.

The [Vaultoro](https://vaultoro.com/?a=109382) ruby gem implements the full API provided by [Vaultoro](https://vaultoro.com/?a=109382). Please note the [Vaultoro](https://vaultoro.com/?a=109382) API is still in beta and is subject to change without notice, consequently this gem may also break without notice. Please report any issues immediately and I will endeavor to patch the gem and issue a release.

To use the gem to issue buy, sell or cancel orders, query your account balance, open orders or closed trades, and withdraw bitcoin; you will need a [Vaultoro](https://vaultoro.com/?a=109382) account and a set of API keys.

## Installation

To install add the following line to your `Gemfile`:

``` ruby
gem 'vaultoro'
```

And run `bundle install`.

Alternatively, you can install it from the terminal:

```
gem install vaultoro
```

## Dependencies

The [Vaultoro](https://vaultoro.com/?a=109382) ruby gem has the following runtime dependencies:
- Virtus ~> 1.0.3

## Compatibility

Developed with MRI 2.4, however the `.gemspec` only specifies MRI 2.2. It may work with other flavors, but it hasn't been tested. Please let us know if you encounter any issues.

## Usage

### Prerequisites

The [Vaultoro](https://vaultoro.com/?a=109382) ruby gem requires an API key and API secret to use the Trading API. By default the library will look for your API key and secret in the environment variables `VAULTORO_API_KEY` and `VAULTORO_API_SECRET`.

### Environments

The [Vaultoro](https://vaultoro.com/?a=109382) ruby gem supports multiple environments. These environments don't have to match your application's environments. By default the environments provided by the client are `:production`, `:test` and `:development`. The default environment is `:production` and the credentials for this environment are read from ENV variables.

If you'd like to override this behavior and provide the API key and/or secret directly to the client, setup a configuration initializer as shown below:

```ruby
Vaultoro.configure do |config|
  config.credentials[:production][:api_key] = "B04B4E74C57C37DE4886"
  config.credentials[:production][:api_secret] = "s3kr3t"
  config.credentials[:production][:api_uri] = "https://api.vaultoro.com"
  config.credentials[:production][:api_version] = 1

  config.credentials[:test][:api_key] = "testapi"
  config.credentials[:test][:api_secret] = "testsecret"
  config.credentials[:test][:api_uri] = "https://api.vaultoro.com"
  config.credentials[:test][:api_version] = 1

  config.credentials[:development][:api_key] = "testapi"
  config.credentials[:development][:api_secret] = "testsecret"
  config.credentials[:development][:api_uri] = "https://api.vaultoro.com"
  config.credentials[:development][:api_version] = 1
end
```

Or pass the values directly to the attributes on the `Vaultoro` namespace:

```ruby
# Set the environment to development:
Vaultoro.environment = :development

# The set the credentials:
Vaultoro.api_key = "B04B4E74C57C37DE4886"
Vaultoro.api_secret = "s3kr3t"
Vaultoro.api_uri = "https://api.vaultoro.com"
Vaultoro.api_version = 1
```

The [Vaultoro](https://vaultoro.com/?a=109382) ruby gem provides flexibility by allowing you to use whatever credentials you want, in whatever environment you want. You can, for instance, add a `:staging` environment if you want:

```ruby
Vaultoro.credentials[:staging][:api_key] = "44CD64EEEFFF887755560B"
Vaultoro.credentials[:staging][:api_secret] = "another_secret"
Vaultoro.credentials[:staging][:api_uri] = "https://api.vaultoro.com"
Vaultoro.credentials[:staging][:api_version] = 1
```

You can query the current list of environments:

```ruby
Vaultoro.environments #=> [:production, :test, :development, :staging]
```

And the currently selected environment:

```ruby
Vaultoro.environment #=> :development
```

The current environment operates independently of any other framework environment, e.g. `Rails.env` or `Rack.env`. You can of course manipulate them to synchronize manually.

### API Calls
The [Vaultoro](https://vaultoro.com/?a=109382) ruby gem provides access to the following [Vaultoro](https://vaultoro.com/?a=109382) API endpoints:

API | Name | Description
--- | --- | ---
Basic | Bid And Ask | A simplified version of the order book.
Basic | Buy Orders | Buy orders currently in the order book.
Basic | Latest Price | Last traded gold price in bitcoin per gram.
Basic | Latest Trades | The latest x number of trades.
Basic | Market Data | Current market data including last, 24 hour low and 24 hour high prices and 24 hour volume.
Basic | Order Book | Current order book (buy and sell orders).
Basic | Sell Orders | Sell orders currently in the order book.
Basic | Transactions | All transactions in the selected timeframe.
Trading | Balances | Your current bitcoin and gold balance in your account.
Trading | Trades | Your fulfilled buy or sell orders.
Trading | Orders | Your open buy or sell orders and see how much volume is still pending.
Trading | Buy | Issue a buy order.
Trading | Cancel | Cancel any buy or sell order.
Trading | Sell | Issue a sell order.
Trading | Withdraw | Withdraw any amount of bitcoin to your saved bitcoin address.

All dates and times are UTC.

### Basic API

The Basic API classes are a collection GET requests that don't require a set of API keys.

#### Bid And Ask

No parameters are required for this API call.

```ruby
@bid_ask = Vaultoro::BasicAPI::BidAsk.new
result = @bid_ask.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @bid_ask.errors.each do |error|
    puts error
  end
end

# Iterate the collection of Vaultoro::BasicAPI::PriceVolume:
@bid_ask.list.each do |price_volume|
  puts price_volume.type     #=> 'bid'
  puts price_volume.price    #=> 0.16644123
  puts price_volume.volume   #=> 1.011
end
```

#### Buy Orders

No parameters are required for this API call.

```ruby
@buy_orders = Vaultoro::BasicAPI::BuyOrders.new
result = @buy_orders.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @buy_orders.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::BasicAPI::Order:
@buy_orders.list.each do |order|
  puts order.gold_amount   #=> 1.5649
  puts order.gold_price    #=> 0.142
end
```

#### Latest Price

No parameters are required for this API call.

```ruby
@latest_price = Vaultoro::BasicAPI::LatestPrice.new
result = @latest_price.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @latest_price.errors.each do |error|
    puts error
  end
end

# Read the gold_price attribute:
@latest_price.gold_price    #=> 0.16548874
```

#### Latest Trades

This API call requires one of following parameters:
- `since` - A transaction_id
- `count` - Number of trades to return (range 1-250)

```ruby
@latest_trades = Vaultoro::BasicAPI::LatestTrades.new

# Request the last 100 trades:
@latest_trades.count = 100
# or all transactions following transaction id 13992101601423:
@latest_trades.since = 13992101601423

result = @latest_trades.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @latest_trades.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::BasicAPI::Trade:
@latest_trades.list.each do |trade|
  puts trade.transaction_id   #=> 13992101601423
  puts trade.price            #=> 0.15273842
  puts trade.amount           #=> 1.824
  puts trade.time             #=> 2018-04-13 07:56:36 UTC
end
```

#### Market Data

No parameters are required for this API call.

```ruby
@market_data = Vaultoro::BasicAPI::MarketData.new
result = @market_data.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @market_data.errors.each do |error|
    puts error
  end
end

# Query the MarketData attributes:
@market_data.market_currency         #=> 'GLD'
@market_data.base_currency           #=> 'BTC'
@market_data.market_currency_name    #=> 'Gold'
@market_data.base_currency_name      #=> 'Bitcoin'
@market_data.min_trade_size          #=> 0.0
@market_data.market_name             #=> 'BTC-GLD'
@market_data.is_active               #=> true
@market_data.min_unit_qty            #=> 0.0002
@market_data.min_price               #=> 0.000002
@market_data.last_price              #=> 0.12414987
@market_data.daily_low               #=> 0.16550209
@market_data.daily_high              #=> 0.16550209
@market_data.daily_volume            #=> 0.067
```

#### Order Book

No parameters are required for this API call.

```ruby
@order_book = Vaultoro::BasicAPI::OrderBook.new
result = @order_book.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @order_book.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::BasicAPI::Order:
@order_book.list.each do |order|
  puts order.gold_amount    #=> 1.5649452112676057
  puts order.gold_price     #=> 0.142
end
```

#### Sell Orders

No parameters are required for this API call.

```ruby
@sell_orders = Vaultoro::BasicAPI::SellOrders.new
result = @sell_orders.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @sell_orders.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::BasicAPI::Order:
@sell_orders.list.each do |order|
  puts order.gold_amount   #=> 1.5649
  puts order.gold_price    #=> 0.142
end
```

#### Transactions

This API call requires one parameter:
- `time` - A timeframe, either 'hour', 'day' or 'month'

```ruby
@transactions = Vaultoro::BasicAPI::Transactions.new

# Request transactions for the day:
@transactions.time = 'day'

result = @transactions.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @transactions.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::BasicAPI::Transaction:
@transactions.list.each do |transaction|
  puts transaction.time           #=> 2018-04-13 07:56:36 UTC
  puts transaction.gold_price     #=> 0.16453745590989327
  puts transaction.gold_amount    #=> 30.236276430118696
end
```

### Trading API

The Trading API classes are a collection GET and POST requests that all require a set of API keys.

#### Balances

No parameters are required for this API call.

```ruby
@balances = Vaultoro::TradingAPI::Balances.new

result = @balances.fetch    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @balances.errors.each do |error|
    puts error
  end
end

# Returns an array containing two balances, one for Gold and the other for Bitcoin.
# Iterate the array of Vaultoro::TradingAPI::Balance:
@balances.list.each do |balance|
  puts balance.currency    #=> 'GLD'
  puts balance.cash        #=> 0.125
  puts balance.reserved    #=> 0
end
```

#### Trades

This API call requires one of following parameters:
- `since` - A time in UTC
- `count` - Number of last trades to return (range 1-250)

```ruby
@trades = Vaultoro::TradingAPI::Trades.new

result = @trades.fetch    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @trades.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::TradingAPI::Trade:
@trades.list.each do |trade|
  puts trade.side              #=> 'BUY'
  puts trade.time              #=> 2018-04-13 07:56:36 UTC
  puts trade.bitcoin_amount    #=> 0.00996
  puts trade.gold_amount       #=> 0.062
  puts trade.gold_price        #=> 0.1592
  puts trade.fee_amount        #=> 0.00031407
  puts trade.fee_currency      #=> 'GLD'
  puts trade.order_id          #=> 'rSaKS2'
end
```

#### Orders

No parameters are required for this API call.

```ruby
@orders = Vaultoro::TradingAPI::Orders.new

result = @orders.fetch    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @orders.errors.each do |error|
    puts error
  end
end

# Iterate the array of Vaultoro::TradingAPI::Order:
@orders.list.each do |order|
  puts order.side              #=> 'BUY'
  puts order.bitcoin_amount    #=> 0.00996
  puts order.gold_amount       #=> 0.062
  puts order.gold_price        #=> 0.1592
  puts order.order_id          #=> 'rSaKS2'
end
```

#### Buy

This API call requires the following parameters:
- `symbol` - Defaults to 'GLD' as this the currently the only symbol
- `type` - Either 'limit' or 'market'
- `price` - Size range: 0.00002-100000 (expressed in bitcoin, ignored for 'market' orders)

And one of the following parameters:
- `bitcoin` - Size range: 0.0002-100000 (expressed in bitcoin)
- `gold` - Size range: 0.001-100000 (expressed in grams)

```ruby
@buy = Vaultoro::TradingAPI::Buy.new

# Specify a 'limit' order:
@buy.type = 'limit'
# or a 'market' order:
@buy.type = 'market'

# Buy 100 grams of gold:
@buy.gold = 100
# or buy 0.5 bitcoin worth of gold:
@buy.bitcoin = 0.05
# or specify the price per gram in bitcoin if this is a 'market' order:
@buy.price = 0.16253

result = @buy.execute!    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @buy.errors.each do |error|
    puts error
  end
end

# Returns an order_id and order_time:
@buy.order_id      #=> 'rSaKS2'
@buy.order_time    #=> 2018-04-13 07:56:36 UTC
```

#### Cancel

This API call requires the following parameter:
- `order_id` - An order_id (6 characters)

```ruby
@cancel = Vaultoro::TradingAPI::Cancel.new
@cancel.order_id = 'kH7d12'

result = @cancel.execute!    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @cancel.errors.each do |error|
    puts error
  end
end

# Returns true if successful:
@cancel.status    #=> true
```

#### Sell

This API call requires the following parameters:
- `symbol` - Defaults to 'GLD' as this the currently the only symbol
- `type` - Either 'limit' or 'market'
- `gold` - Size range: 0.001-100000 (expressed in grams)
- `price` - Size range: 0.00002-100000 (expressed in bitcoin, ignored for 'market' orders)

```ruby
@sell = Vaultoro::TradingAPI::Sell.new

# Specify a 'limit' order:
@sell.type = 'limit'
# or a 'market' order:
@sell.type = 'market'

# Sell 100 grams of gold:
@sell.gold = 100
# or specify the price per gram in bitcoin:
@sell.price = 0.16253

result = @sell.execute!    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @sell.errors.each do |error|
    puts error
  end
end

# Returns an order_id and order_time:
@sell.order_id      #=> 'kH7d12'
@sell.order_time    #=> 2018-04-13 07:56:36 UTC
```

#### Withdraw

This API call requires the following parameter:
- `bitcoin` - The amount of bitcoin to withdraw to your pre-saved withdrawal address (size range: 0.00010001-100000)

```ruby
@withdraw = Vaultoro::TradingAPI::Withdraw.new

# Specify the amount of bitcoin to withdraw:
@withdraw.bitcoin = 0.5

result = @withdraw.execute!    #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
unless result
  @withdraw.errors.each do |error|
    puts error
  end
end

# Returns true if successful:
@withdraw.status    #=> true

# Reports the address at which the withdrawal was made to:
@withdraw.address    #=> '3DcT7S4znnpcmYeig89biVwxcFAaCsQNWT'
```

## Testing

Tests are yet to be written, hence the `pre` version number. Since the next Vaultoro API is currently in discussion and I've been invited to discuss the new API, I decided to hold off on writing tests until I know where this API is heading.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credit

This gem was written and is maintained by [Jurgen Jocubeit](https://github.com/JurgenJocubeit), co-founder at [Exavest](https://www.exavest.com).

## Disclaimer

The links to [Vaultoro](https://vaultoro.com/?a=109382) on this page contain an affiliate link, please use the links to help toward maintaining this API client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright 2018 Jurgen Jocubeit. All rights reserved.
