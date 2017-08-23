class ApiKeysController < ApplicationController
  before_action :set_api_key, only: [:sync, :edit, :update, :destroy]
  before_action :authenticate_user!


  # GET /api
  # GET /api.json
  def index
    @api_keys = current_user.api_keys.all
  end

  # GET /api/new
  def new
    @api_key = ApiKey.new
  end

  # GET /api/1/edit
  def edit
  end

  def sync
    @results = @api_key.sync
    return respond_with_invalid_key(@api_key.name)  if @results == "APIKEY_INVALID"

    respond_to do |format|
      format.html { redirect_to trades_path, notice: "Successfully synchronized." }
      format.js {
        if @results and @results != "APIKEY_INVALID"
          @count = 0
          if success = @results.select { |e| e[:status] == :success }
            @coins = success.collect { |e| e[:coin_name] }
            @count = success.inject(0){|a,b| a + b[:message]}
          end
          @errors = @results.select { |e| e[:status] == :error }.collect { |e| e[:message] }
        end
      }
    end
  end

  # POST /api
  # POST /api.json
  def create
    @api_key = current_user.api_keys.new(api_key_params)

    respond_to do |format|
      if @api_key.save
        format.html { redirect_to api_keys_url, notice: 'Api was successfully created.' }
        format.json { render :show, status: :created, location: api_keys_url }
      else
        format.html { render :new }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/1
  # PATCH/PUT /api/1.json
  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        format.html { redirect_to api_keys_url, notice: 'Api was successfully updated.' }
        format.json { render :show, status: :ok, location: api_keys_url }
      else
        format.html { render :edit }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/1
  # DELETE /api/1.json
  def destroy
    @api_key.destroy
    respond_to do |format|
      format.html { redirect_to api_keys_url, notice: 'Api was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_key_params
      params.require(:api_key).permit(:exchange_id, :name, :key, :secret)
    end
end
