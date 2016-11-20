module WeatherWeb
  class Index < Sinatra::Base
    require 'active_record'
    require 'sinatra/json'

    register Sinatra::StaticAssets
    register Sinatra::Reloader
    register Sinatra::SessionHelper

    enable :sessions
      configure do

        set :root => File.dirname(__FILE__)

        set :public_folder => File.join(root + '/public')

        set :show_exceptions, :after_handler

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
        data = current_user.to_json
        data
      else
        data = {:error => "bad credentials"}.to_json
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
=begin
    get '/favorites/json' do
      if current_user.nil?
        error_message("You must be logged in!")
        redirect '/error'
      end
      curr_fav = Favorites.where(:users_id => "#{current_user.id}").limit(10)
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
      ordered_results.to_json
    end

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

    post '/favorites/destroy' do
      fav_to_del = params[:city_id]
      favorites = Favorites.where(users_id: current_user.id)
      favorites.each do |fav|
        if fav.city_id == fav_to_del
          Favorites.destroy(fav.id)
        end
      end
      session[:msg] = 'City removed successfully'
      redirect '/favorites'
    end

  end
end

