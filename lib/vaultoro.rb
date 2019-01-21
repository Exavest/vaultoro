require 'vaultoro/base'
require 'vaultoro/version'
require 'vaultoro/configuration'
require 'vaultoro/basic_api/client'
require 'vaultoro/basic_api/bid_ask'
require 'vaultoro/basic_api/buy_orders'
require 'vaultoro/basic_api/latest_price'
require 'vaultoro/basic_api/latest_trades'
require 'vaultoro/basic_api/market_data'
require 'vaultoro/basic_api/order'
require 'vaultoro/basic_api/order_book'
require 'vaultoro/basic_api/price_volume'
require 'vaultoro/basic_api/sell_orders'
require 'vaultoro/basic_api/trade'
require 'vaultoro/basic_api/transaction'
require 'vaultoro/basic_api/transactions'
require 'vaultoro/trading_api/client'
require 'vaultoro/trading_api/balance'
require 'vaultoro/trading_api/balances'
require 'vaultoro/trading_api/buy'
require 'vaultoro/trading_api/cancel'
require 'vaultoro/trading_api/order'
require 'vaultoro/trading_api/orders'
require 'vaultoro/trading_api/sell'
require 'vaultoro/trading_api/trade'
require 'vaultoro/trading_api/trades'
require 'vaultoro/trading_api/withdraw'

module Vaultoro
  @@configuration = nil

  def self.configure
    @@configuration = Configuration.new
    yield(configuration) if block_given?
    configuration
  end

  def self.configuration
    @@configuration || configure
  end

  def self.method_missing(method_sym, *arguments, &block)
    if configuration.respond_to?(method_sym)
      configuration.send(method_sym)
    else
      super
    end
  end

  def self.respond_to?(method_sym, include_private = false)
    if configuration.respond_to?(method_sym, include_private)
      true
    else
      super
    end
  end
end
