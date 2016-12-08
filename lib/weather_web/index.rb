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
      @data = ForecastData.new
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

    get '/api/result' do
      type_forecast = 'weather'
      user_input = params['city_name']
      @result = @data.get_city_id(user_input)
      response = ''
      if @result.length > 1
        multiple_results = @result
        data = {:multiple_results => multiple_results}.to_json
        data
      else
        @result.each{|res| response = @data.request_weather(res[:city_id],type_forecast)}
        data = {:result => response}.to_json
        data
      end
    end

    get '/api/multiple_results' do
      common = WeatherApp::Common.new
      cache = WeatherCache.new
      record = WeatherCache.find_by(:city_id => params[:city_id])
      if record.nil?
        forecast_data = common.get_data(params[:city_id],'weather')
        response = cache.cache_it(forecast_data,params[:city_id])
        data = {:result => response}.to_json
        data
      else
        response = cache.record_from_cache(params[:city_id])
        data =  {:result => response}.to_json
        data
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
      if username.length > 6 && password.length > 6
        user = User.new(attributes={
            username: username,
            password: password
        })
        if user.save
          session[:user_id] = user.id
        else
          data = {:message => "Something wrong with the database try again later."}.to_json
          data
        end
      else
        data = {:message => "Username/Password must be longer than 6 symbols"}.to_json
        data
      end
      data = {:message => "Account created successfully."}.to_json
      data
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

    get '/api/forecast' do
      id = params[:id]
      curr_fav = Favorites.where(:users_id => "#{id}").limit(10)
      count = 1
      forecast_fav = []
      forecast = @five_day.five_day_data(curr_fav,(Date.today))
      all_days = @parser.add_icon_multiple(forecast)
      forecast_fav.push(all_days)
      until count == 5 do
        forecast = @five_day.five_day_data(curr_fav,(Date.today + count))
        all_days = @parser.add_icon_multiple(forecast)
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

    get '/api/city' do
      city = params[:city]
      city_list = CityList.new
      result = {:citys => city_list.find_city_by_name(city)}
      result.to_json
    end


    put '/api/update_favorites' do
      fav_id = ''
      curr_user = ''
      request.body.each do |req|
        hash = JSON.parse(req, :symbolize_names => true)
        fav_id = hash[:city]
        curr_user = hash[:curr_user][:id]
      end
      new_fav = Favorites.new(attributes={
          users_id: curr_user,
          name: fav_id[:city_name],
          city_id: fav_id[:city_id]
      })
      user_favorites = Favorites.where(users_id: curr_user)
      user_favorites.each do |fav|
        if fav.city_id.to_i != fav_id[:city_id].to_i
          new_fav.save

        else
          puts 'Has'
        end
      end
      data = Favorites.where(users_id: curr_user).to_json
      data
    end

    delete '/api/remove_favorite' do
      favorite = Favorites.where(users_id: params['user_id']).where(city_id: params['id'])
      favorite.each{|fav| Favorites.destroy(fav.id)}
      data = Favorites.where(users_id: params['user_id']).to_json
      data
    end

    get '/api/forecast_by_id' do
      forecast = FiveDayForecast.where(:city_id => params['city_id'])
      today = Date.today
      arr = []
      count = 0
      simplified_forecast = []
      until count == 5 do
      forecast.each do |f|
        if(Time.at(f.timestamp).to_date === today + count)
          arr.push(f)
        end
      end
      middle = arr.length / 2 - 1
      daily_forecast = Hash.new
      daily_forecast[:temp_min] = arr.first.temp_min
      daily_forecast[:temp_max] = arr[middle].temp_max
      daily_forecast[:date] = Date.parse(arr.first.timestamp.to_s)
      daily_forecast[:day] = Date.parse(arr.first.timestamp.to_s).strftime('%A')
      daily_forecast[:weather_type] = arr[middle].weather_type
      @parser.add_icon_single(daily_forecast)
      simplified_forecast.push(daily_forecast)
      arr = []
      count += 1
      end
      simplified_forecast
      data = {:forecast => forecast, :simplified_forecast => simplified_forecast}.to_json
      data
    end
  end
end

