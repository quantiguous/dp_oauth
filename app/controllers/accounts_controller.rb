require 'net/https'
require 'open-uri'
require 'httplog'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :get_balance]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end
    
  def get_balance
    if request.get? 
      redirect_to @account
    else
      if session[:access_token].nil?
        uri = URI.parse('https://192.168.79.137/qg/sb/httpbin/oauth/authorize')
        params = {response_type: :token, scope: '/httpbin', client_id: '2c2627db-46dc-4d66-848a-b481cb8399f9'}
        uri.query = URI.encode_www_form(params)
      
      
        res = Net::HTTP.get_response(uri)
        
        if res.code == '302'
          redirect_to res['location']
        else
          if res['content-type'] == 'text/html'
            render text: res.body
          else
            @account.errors.add(:base, res.body)
            render action: :show
          end
        end
      else
        uri = URI.parse('https://192.168.79.137/qg/sb/httpbin/uuid')
        req = Net::HTTP::Get.new(uri.path)
        req.add_field('X-IBM-Client-Id', '2c2627db-46dc-4d66-848a-b481cb8399f9')
        req.add_field('Authorization', "Bearer #{session[:access_token]}")
        
        p "#{req}"        
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = http.request(req)
        p "#{res}"
        
        if res.code == '200'
          @account.balance = res.body.to_s
        else
          @account.errors.add(:base, "#{res.body} --- access_token : #{session[:access_token]}")
        end
        render action: :show         
      end
    end
  end
  
  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:app_id, :customer_id, :account_no)
    end
end
