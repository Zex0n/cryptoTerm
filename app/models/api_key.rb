class ApiKey < ActiveRecord::Base
  belongs_to :user
  belongs_to :exchange

  before_save :strip_whitespace

  validates :key, presence: true, uniqueness: true, length: { minimum: 6 }, :format => { :with => /\A[a-z0-9\s]+\z/i }
  validates :secret, uniqueness: true, length: { minimum: 6 }, :format => { :with => /\A[a-z0-9\s]+\z/i }
  validates :name, presence: true, length: { in: 2..14 }

  def strip_whitespace
    self.key.gsub!(/\s+/, '')
    self.secret.gsub!(/\s+/, '')
    self.name.gsub!(/\s+/, '')
  end

  def sync
    results = []
    trx = Bittrex.new(key, secret)
    history = trx.order_history(nil, 500)
    return "APIKEY_INVALID"  if history == "APIKEY_INVALID"
    coin_tags = history.compact.collect{|e| e['Exchange'].split("-")[1]}.uniq
    coin_tags.each do |coin_tag|
      coin = Coin.find_or_create(tag: coin_tag)
      history = trx.order_history(coin_tag, 500)
      next  if history == "INVALID_MARKET"
      results << OrdersHistory.add_from_api(coin, exchange_id, user_id, history)
      sleep 1
    end
    results
  end

  def self.system
    ## todo: fix it for many exchanges ##
    self.first
  end

  def self.list
    ## todo: fix it for many exchanges ##
    self.all
  end

end
