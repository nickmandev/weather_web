module WeatherWeb
  class Index < Sinatra::Base
    require 'active_record'
    require 'sinatra/json'
    require 'jwt'

    register Sinatra::StaticAssets
    register Sinatra::Reloader
    register Sinatra::SessionHelper
    register Sinatra::CrossOrigin

    SIGNING_KEY_PATH = File.expand_path("../../../weather_web.rsa", __FILE__)
    VERIFY_KEY_PATH = File.expand_path("../../../weather_web.rsa.pub", __FILE__)

    before do
      halt 200 if request.request_method == "OPTIONS"
      @five_day = FiveDayForecast.new
      @parser = DataParser.new
    end

    enable :sessions
      configure do

        enable :cross_origin

        set :root => File.dirname(__FILE__)

        set :public_folder => File.join(root + '/public')

        set :show_exceptions, :after_handler

        signing_key = ""
        verify_key = ""

        File.open(SIGNING_KEY_PATH) do |file|
          signing_key = OpenSSL::PKey.read(file)
        end

        File.open(VERIFY_KEY_PATH) do |file|
          verify_key = OpenSSL::PKey.read(file)
        end

        set :signing_key, signing_key

        set :verify_key, verify_key

      end

  helpers do
    def current_user
      if session[:user_id] != nil
        current_user = User.find(session[:user_id])
      end
    end

    def error_message(value)
      message = value
      session[:error] = message
    end

    def extract_token
      token = request.env['access_token']

    if token
      return token
    end

    token = request['access_token']

    if token
      return token
    end

    token = session['access_token']

    if token
      return token
    end

    return nil
    end

    def authorized?
      @token = extract_token
      begin
        payload, header = JWT.decode(@token, settings.verify_key, true)

        @exp = header['exp']

        if @exp.nil?
          puts "Access token doesn't have exp set"
          return false
        end

        @exp = Time.at(@exp.to_i)

        if Time.now > @exp
          puts 'Access token expired'
          return false
        end

        @user_id = payload['user_id']

      rescue JWT::DecodeError => e
        return false
      end
    end
  end

=begin
    get '/error' do
      session[:error]
      erb :error
    end
=end

    post '/result' do
      begin
      type_forecast = 'weather'
      user_input = params[:city]
      raise ArgumentError if user_input.blank?
      rescue ArgumentError
        error_message('Search field cannot be blank.')
        redirect '/error'
      end
      begin
      @result = @data.get_city_id(params[:city])
      raise StandardError if @result.blank?
      rescue StandardError
        error_message('City not found. Check for typos.')
        redirect '/error'
      end
      response = ''
      if @result.length > 1
        test = @result
        erb :multiple_results, locals: {:multiple_results => test}
      else
        @result.each{|res| response = @data.request_weather(res[:city_id],type_forecast)}
        erb :single_result, locals: {:result => response}
      end
    end

    post '/multiple_results' do
      common = WeatherApp::Common.new
      cache = WeatherCache.new
      record = WeatherCache.find_by(:city_id => params[:city_id])
      if record.nil?
        forecast_data = common.get_data(params[:city_id],'weather')
        response = cache.cache_it(forecast_data,params[:city_id])
        erb :single_result, locals: {:result => response}
      else
        response = cache.record_from_cache(params[:city_id])
        erb :single_result, locals: {:result => response}
      end
    end

=begin
    get '/signup' do
      erb :signup
    end
=end

    post '/api/signup' do
      username = ''
      password = ''
      request.body.each do |req|
        hash = JSON.parse(req, :symbolize_names => true)
        username = hash[:username]
        password = hash[:password]
      end
      user = User.new(attributes={
          username: username,
          password: password
      })
      if user.save
        session[:user_id] = user.id
      else
        begin
          raise ArgumentError
        rescue ArgumentError
          puts "There's a problem!"
        end
      end
    end


    post '/api/login' do
      user =''
      pass = ''

      request.body.each do |req|
        hash = JSON.parse(req,:symbolize_names => true)
        user = hash[:username]
        pass = hash[:password]
      end
      user = User.find_by(:username => user)
      if user && user.authenticate(pass)
        session[:user_id] = user.id
        headers = {
            exp: Time.now.to_i + 900
        }

        @token = JWT.encode({user_id: user.id}, settings.signing_key, "RS256", headers)
        data = {:token => @token,:current_user => current_user}.to_json
        data
      else
        puts 'Wrong cred'
        data = {:error => "Account and/or Password was incorect!"}.to_json
        data
      end
    end


=begin
    get '/logout' do
      session[:user_id] != nil
        session.destroy
        redirect '/'
    end
=end
    get '/' do
      redirect './javascript/app/index.html'
    end

    post '/api/favorites' do
      id = ""
      request.body.each do |req|
        hash = JSON.parse(req,:symbolize_names => true)
        id = hash[:id]
      end
      curr_fav = Favorites.where(:users_id => "#{id}").limit(10)
      count = 1
      forecast_fav = []
      forecast = @five_day.five_day_data(curr_fav,(Date.today))
      all_days = @parser.add_icon(forecast)
      forecast_fav.push(all_days)
      until count == 5 do
        forecast = @five_day.five_day_data(curr_fav,(Date.today + count))
        all_days = @parser.add_icon(forecast)
        forecast_fav.push(all_days)
        count += 1
      end
      forecast_fav.flatten!
      ids = []
      ordered_results = []
      curr_fav.each{|fav| ids.push(fav[:city_id]) }
      ids.each do |id|
        forecast_fav.each do |fav|
          if id == fav[:city_id]
            ordered_results.push(fav)
          end
        end
      end
      ordered_results
      content_type :json
      data = {:forecastFavorites => ordered_results, :favorites => curr_fav}.to_json
      data
    end
=begin
    get '/favorites' do
      erb :favorites
    end
=end

    post '/favorites' do
      new_fav = Favorites.new(params[:fav])
      if !new_fav.check_if_exist(current_user.id, params[:fav][:city_id])
        new_fav.save
        redirect '/'
      elsif new_fav.check_if_exist(current_user.id, params[:fav][:city_id])
        redirect '/error',  error_message('This city is already in Favorites.')
      else
        begin
          raise StandardError
        rescue StandardError
          error_message("There's a problem! With the database.")
          redirect '/error'
        end
      end
    end

    delete '/api/remove_favorite' do
      favorite = Favorites.where(users_id: params['user_id']).where(city_id: params['id'])
      favorite.each{|fav| Favorites.destroy(fav.id)}
      data = {:response => 'Removed'}.to_json
      data
    end
  end
end

