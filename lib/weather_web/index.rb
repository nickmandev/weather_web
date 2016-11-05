module WeatherWeb
  class Index < Sinatra::Base
    require 'active_record'

    attr_accessor :data, :errors, :current_user

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

    def current_user
      session[:user]
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
      data = ForecastData.new
      param = data.get_city_id(params[:city])
      session[:result] = param
      if !param.kind_of?(String) && param.length > 1
        redirect ('/multiple_results')
      end
      request = data.request_data(param)
      session[:single_result] = request
      if data.results.length == 0
        error_message('ERROR(Enter a city name) To get back click on Weather')
        redirect '/error'
      end
      if data.request_data(param).nil?
        error_message("There's something wrong with the connection please try again later!")
        redirect '/error'
      end
      erb :result
    end

    get '/multiple_results' do
      session[:result]
      erb :multiple_results
    end

    post '/multiple_results' do
      common = WeatherApp::Common.new
      cache = WeatherCache.new
      record = WeatherCache.find_by(:city_id => params[:city_id])
      if record.nil?
        forecast_data = common.get_data(params[:city_id],'weather')
        if forecast_data.nil?
          error_message("There's something wrong with the connection please try again later!")
          redirect '/error'
        end
        response = cache.cache_it(forecast_data,params[:city_id])
        session[:single_result] = response
      else
        response = cache.record_from_cache(params[:city_id])
        session[:single_result] = response
      end


      erb :result
    end

    get '/signup' do
      erb :signup
    end

    post '/signup' do
      session[:error]
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        redirect '/index', 'Account Created!'
      else
        redirect '/error', error_message("There's a problem!")
      end
    end

    get '/login' do
      erb :login
    end

    post '/login' do
      user = User.find_by(:username => params[:user][:username])
      if user && user.authenticate(params[:user][:password])
        session[:current_user] = user
        session[:user_id] = user.id
        redirect '/', 'Logged in!'
      else
        redirect '/error', error_message('Wrong username/password combination!')
      end
    end

    get '/logout' do
      if
      session[:user_id] != nil
        session.destroy
        redirect '/'
      else
        redirect '/'
      end
    end

    get '/' do
      fav = Favorites.new
      if session[:current_user] != nil
        current_user_id = session[:current_user].id
        curr_fav = Favorites.where(:users_id => "#{current_user_id}").limit(10)
        forecast_fav = fav.forecast_for_favorites(curr_fav)
        session[:fav] = forecast_fav
      end
      erb :index
    end

    post '/' do
      cur_usr = session[:current_user]
      fav = Favorites.new(params[:fav])
      if !fav.check_if_exist(cur_usr, params[:fav][:city_id])
        fav.save
        redirect '/'
      elsif fav.check_if_exist(cur_usr, params[:fav][:city_id])
        redirect '/error',  error_message('This city is already in Favorites.')
      else
        redirect '/error',  error_message("There's a problem!")
      end
    end
  end
end
