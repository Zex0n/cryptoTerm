class OrdersController < ApplicationController
  def index
    require 'bittrex'
    @order = ApiKey.where(user: current_user).first
    Bittrex.config do |c|
      c.key = @order.open
      c.secret = @order.secret
    end

    @quote = Bittrex::Quote.current('BTC-ETH')
    @history = Bittrex::Wallet
  end
end
