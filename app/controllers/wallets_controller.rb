class WalletsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_wallet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html, :js


  # GET /wallets
  # GET /wallets.json
  def index
    authorize! :read, Wallet
    @wallets = Wallet.where(:user => current_user).all
  end

  def load
    if request.post?
      api = current_user.api_keys.first
      Wallet.autoupdate(current_user)
      flash[:notice] = "All balances successful updated!"
      redirect_to wallets_path
    end
  end

  # GET /wallets/1
  # GET /wallets/1.json
  def show
  end

  # GET /wallets/new
  def new
    authorize! :create, Wallet
    @wallet = Wallet.new
  end

  # GET /wallets/1/edit
  def edit
    authorize! :edit, @wallet
    @trades = Trade.where(:user => current_user, :coin_id => @wallet.coin_id).all
    print "------------\n\r"
    print(@trades.inspect)
  end

  # POST /wallets
  # POST /wallets.json
  def create
    authorize! :create, Wallet
    @wallet = Wallet.new(wallet_params)
    @wallet.user = current_user

    respond_to do |format|
      if @wallet.save
        format.html { redirect_to @wallet, notice: 'Wallet was successfully created.' }
        format.json { render :show, status: :created, location: @wallet }
      else
        format.html { render :new }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallets/1
  # PATCH/PUT /wallets/1.json
  def update
    authorize! :edit, @wallet
    respond_to do |format|
      if @wallet.update(wallet_params)
        format.html { redirect_to @wallet, notice: 'Wallet was successfully updated.' }
        format.json { render :show, status: :ok, location: @wallet }
      else
        format.html { render :edit }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallets/1
  # DELETE /wallets/1.json
  def destroy
    authorize! :destroy, @wallet
    @wallet.destroy
    respond_to do |format|
      format.html { redirect_to wallets_url, notice: 'Wallet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wallet_params
      params.require(:wallet).permit(:exchange_id, :coin_id, :balance, :available, :pending, :buy_price)
    end
end
