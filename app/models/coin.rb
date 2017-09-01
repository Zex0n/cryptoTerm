class Coin < ActiveRecord::Base
  belongs_to :exchange

  default_scope { order('name') }

  def update_price
    api = ApiKey.system
    # todo: fix exchanges
    coin_tag = self.tag.split("-")
    bittrex = Bittrex.new(api.key, api.secret, coin_tag[0])
    ticker = bittrex.ticker(coin_tag[1])
    self.update_attribute :current_price, (ticker['Bid'] + ticker['Ask']) / 2
  end

  def self.autoupdate
    apis = ApiKey.list
    apis.each do |api|
      # todo: fix exchanges
      api_exchange = api.exchange
      if (api_exchange.short_name == "BTRX")
        bittrex = Bittrex.new(api.key, api.secret)
        coins = bittrex.summaries
      end

      return false unless coins
      coins.each do |coin|
        # name = coin['MarketName'].split("-")[1]
        name = coin['MarketName']
        coin_in_base = Coin.create_with(name: name, tag: name).find_or_initialize_by(name: name)
        if coin['Bid'] && coin['Ask']
          coin_in_base.current_price = (coin['Bid'] + coin['Ask']) / 2
          coin_in_base.current_volume = (coin["BaseVolume"] || 0.0)
          coin_in_base.exchange_id = api_exchange
          coin_in_base.save!
        end
      end
    end
  end

  def self.find_or_create(options)
    if new_coin = self.create_with(name: options[:tag]).find_or_initialize_by(tag: options[:tag]) and new_coin.new_record?
      new_coin.update_price
      new_coin.save!
    end
    new_coin
  end
end
