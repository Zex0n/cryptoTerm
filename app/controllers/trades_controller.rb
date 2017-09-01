class TradesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :authenticate_user!
  before_action :set_trade, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /trades
  # GET /trades.json
  def index
    authorize! :read, Trade
    @orders_history = OrdersHistory.new
    user = params[:username].present? ? User.find_by(username: params[:username]) : current_user
    @trades = user.all_trades
  end

  def debug
    user = User.where(username: params[:username]).first
    api = user.api_keys.first
    trx = Bittrex.new(api.key, api.secret)
    @history = trx.order_history(params[:coin], 500)
    
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
    authorize! :read, @trade
    @selected_round = params[:round].presence || @trade.current_round_number
    @orders_histories = @trade.load_orders_histories  unless request.xhr?
    @round = Round.where(user_id: current_user.id, coin_id: @trade.coin_id, round_number: @selected_round).first

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /trades/new
  def new
    authorize! :create, Trade
    @trade = Trade.new
  end

  # GET /trades/1/edit
  def edit
    authorize! :edit, @trade
  end

  # POST /trades
  # POST /trades.json
  def create
    authorize! :create, Trade


    # ToDo parse csv file
    # https://github.com/tilo/smarter_csv


    if params[:file]

      options = {:file_encoding => "UTF-16"}
      File.open(params[:file].tempfile, "r:UTF-16LE") do |f|
        @csvs = SmarterCSV.process(f, options);
      end
      @csvs.each do |csv|
        order_type = ""
        if csv[:type] == "LIMIT_BUY"
          order_type = "Buy"
        elsif csv[:type] == "LIMIT_SELL"
          order_type = "Sell"
        end

        amount = csv[:quantity]
        price = csv[:limit]

        if csv[:exchange].include? "-"
          csv_coin_name = csv[:exchange].sub("BTC-", "")
        end
        coin_obj = Coin.find_by_name(csv_coin_name)
        print(csv_coin_name)
        if coin_obj
          one_param = {:orders_history=>{:coin_id=>coin_obj.id, :exchange_id=>params[:exchange_id], :order_type=>order_type, :amount=>amount, :price=>price}}
          parser = CoinParser.new(one_param, current_user)
          parser.result
          print(one_param)
          print("\n\r\n\r")
        end
      end

      @result = {:message => "Successfully imported", :status => :success}

      print(@csvs)

=begin
      lines = params[:file].tempfile.readlines.map(&:chomp) #readlines from file & removes newline symbol
      lines.shift #remove first line
      lines.each do |l|
        m = l.match(/(\S+)\s(\d+)\s(\S+)/) #parse line
        Student.create {name: m[1],age: m[2], occupation: m[3]}
      end
=end

    else
      print(params)
      parser = CoinParser.new(params, current_user)
      @result = parser.result
    end

    respond_to do |format|
      format.html {
        response_with(notice: @result[:message])  if @result[:status] == :success
        response_with(alert: "Trade not saved: #{@result[:message]}") if @result[:status] == :error
      }
      format.js { 
         @trade = current_user.trades.last  if @result[:status] == :success
      }
    end
  end

  def refresh
    @trade = Trade.includes(:coin, {user: :api}).find(params[:id])
    coin = @trade.coin
    coin.update_price
    authorize! :edit, @trade
    current_user.api_keys.all.each do |api|
      # todo: fix exchanges
      exchange = Bittrex.new(api.key, api.secret)
      history = exchange.order_history(coin.tag, 500)
      return respond_with_invalid_key(api.name)  if history == "APIKEY_INVALID"
      @result = OrdersHistory.add_from_api(coin, Exchange.first.id, current_user.id, history)
    end

    respond_to do |format|
      format.html {
        response_with(notice: "#{pluralize @result[:message], "order"} has been added.")  if @result[:status] == :success
        response_with(alert: "Trade not saved: #{messages_to_list @result[:message]}")  if @result[:status] == :error
      }
      format.js
    end
  end

  # PATCH/PUT /trades/1
  # PATCH/PUT /trades/1.json
  def update
    authorize! :edit, @trade
    @trade.assign_attributes(trade_params)
    respond_to do |format|
      if @trade.save(trade_params)
        format.html { redirect_to @trade, notice: 'Trade was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade }
      else
        format.html { render :edit }
        format.json { render json: @trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
  def destroy
    authorize! :destroy, @trade
    @trade.destroy
    respond_to do |format|
      format.html { redirect_to trades_url, notice: 'Trade was successfully destroyed.' }
      format.js
    end
  end

  def csv_import
    authorize! :create, Trade


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade
      @trade = Trade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_params
      params.require(:trade).permit(
        :user_id, 
        :coin_id, 
        :exchange_id, 
        :amount_bought, 
        :price_bought, 
        :amount_sold, 
        :price_sold, 
        :amount_left, 
        :amount_value, 
        :profit, 
        :percent,
        :current_round_number)
    end

    def orders_history_params
      params.require(:orders_history).permit(:coin_id, :exchange_id, :order_type, :amount, :price)
    end

    def response_with(message)
      redirect_to(trades_path(username: current_user.username), message)
    end
end
