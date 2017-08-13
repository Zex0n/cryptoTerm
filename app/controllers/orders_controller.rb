class OrdersController < ApplicationController
  def index
    require 'bittrex'
    @apiKey = ApiKey.where(user: current_user).first
    Bittrex.config do |c|
      c.key = @apiKey.open
      c.secret = @apiKey.secret
    end

    @quote = Bittrex::Quote.current('BTC-ETH')
    @history = Bittrex::Order.history
  end
end
