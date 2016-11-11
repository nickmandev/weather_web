module WeatherWeb
  class Index < Sinatra::Base
    require 'active_record'

    register Sinatra::StaticAssets
    register Sinatra::Reloader
    register Sinatra::SessionHelper

    enable :sessions
      configure do

        set :root => File.dirname(__FILE__)

        set :public_folder => File.join(root + '/public')

        set :show_exceptions, :after_handler

        set :template_engine, :erb

      end
    helpers do
       def logged_in?
         !!session[:user_id]
       end
    end

    before do
      @data = ForecastData.new
      @cache = WeatherCache.new
      @fav = Favorites.new
      @five_day = FiveDayForecast.new
    end

    def current_user
      if session[:user_id] != nil
        current_user = User.find(session[:user_id])
      end
    end

    def error_message(value)
      message = value
      session[:error] = message
    end

    get '/error' do
      session[:error]
      erb :error
    end

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

    get '/signup' do
      erb :signup
    end

    post '/signup' do
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        redirect '/index', 'Account Created!'
      else
        begin
          raise ArgumentError
        rescue ArgumentError
          error_message("There's a problem!")
          redirect '/error'
        end
      end
    end

    get '/login' do
      erb :login
    end

    post '/login' do
      user = User.find_by(:username => params[:user][:username])
      if user && user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        redirect '/'
      else
        redirect '/error', error_message('Wrong username/password combination!')
      end
    end

    get '/logout' do
      session[:user_id] != nil
        session.destroy
        redirect '/'
    end

    get '/' do
      erb :index
    end

    get '/favorites' do
      curr_fav = Favorites.where(:users_id => "#{current_user.id}").limit(10)
      @five_day.five_day_data(curr_fav)
      forecast_fav = @fav.forecast_for_favorites(curr_fav)
      erb :favorites, locals: {:favorites => forecast_fav}
    end

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
