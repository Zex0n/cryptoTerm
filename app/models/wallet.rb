class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :exchange
  belongs_to :coin
  default_scope { order(:balance => :desc) }

  def self.autoupdate(user)
    api = ApiKey.system
    # todo: fix exchanges
    bittrex = Bittrex.new(api.key, api.secret)
    balances = bittrex.balances

    return false unless balances
    balances.each do |balance|
      name = balance['Currency']

      # create coin if not exist and get its prices
      coin_in_base = Coin.create_with(name: name, tag: name).find_or_initialize_by(name: name)

      ticker = bittrex.ticker(name)
      if ticker['Bid'] && ticker['Ask']
        coin_in_base.current_price = (ticker['Bid'] + ticker['Ask']) / 2
        coin_in_base.current_volume = (ticker["BaseVolume"] || 0.0)
        coin_in_base.save!
      end

      # create balance row
      balance_in_base = Wallet.create_with(user: user, coin: coin_in_base, exchange_id: api.exchange_id).find_or_initialize_by(coin: coin_in_base)
      if balance['Balance'] > 0
        balance_in_base.balance = balance['Balance']
        balance_in_base.available = balance['Available']
        balance_in_base.pending = balance['Pending']
        balance_in_base.save!
      end
    end

    Coin.autoupdate

  end

end
