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
      get '/' do
        erb :index
      end


        post '/result' do
          data = WeatherWeb::ForecastData.new
          parser = WeatherWeb::DataParser.new
          param = data.get_city_id(params[:city])
          session[:result] = data.results
            if data.results.length > 1
              redirect ('/multiple_results')
            end
          request = data.request_data(param)
          session[:single_result] = request
            if params[:city].length == 0
              errors = "ERROR(Enter a city name) To get back click on Weather"
              session[:error] = errors
              redirect '/error'
            end
            if data.request_data(param).nil?
              errors = "There's something wrong with the connection please try again later!"
              session[:error] = errors
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
          cache = WeatherWeb::WeatherCache.new
          record = WeatherWeb::WeatherCache.find_by(:city_id => params[:city_id])
          if record.nil?
            forecast_data = common.get_data(params[:city_id])
            response = cache.cache_it(forecast_data,params[:city_id])
            session[:single_result] = response
          else
           response = cache.check_if_updated(params[:city_id])
            session[:single_result] = response
          end
          if common.get_data(params).nil?
            errors = "There's something wrong with the connection please try again later!"
            session[:error] = errors
            redirect '/error'
          end

          erb :result
        end

        get '/error' do
          session[:error]
          erb :error
        end

        get '/signup' do
          erb :signup
        end

        post '/signup' do
          session[:error]
          @user = User.new(params[:user])
          if @user.save
            session[:user_id] = @user.id
            redirect '/index', "Account Created!"
          else
            redirect '/error', session[:error] = "There's a problem!"
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
            redirect '/', "Logged in!"
          else
            redirect '/error', session[:error] = "Wrong username/password combination!"
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

        get '/favorites' do
          parser = WeatherWeb::DataParser.new
          if session[:current_user] == nil
            redirect '/error', session[:error] = "You must be logged in to view your Favorites!"
          end
          fav = WeatherWeb::Favorites.new
          curr_fav = fav.user_favorites(session[:current_user])
          forecast_fav = fav.forecast_for_favorites(curr_fav)
          session[:fav] = forecast_fav
          erb :favorites
        end

        post '/favorites' do
          cur_usr = session[:current_user]
          fav = Favorites.new(params[:fav])
          fav.users_id = cur_usr.id
            if fav.check_if_exist(cur_usr, params[:fav][:city_id]) == false
            fav.save
              redirect '/favorites'
            elsif fav.check_if_exist(cur_usr, params[:fav][:city_id]) == true
              redirect '/error', session[:error] = "This city is already in Favorites."
            else
              redirect '/error', session[:error] = "There's a problem!"
            end
        end

        post '/favorites_' do
          @data = WeatherWeb::ForecastData.new
          @data.get_city_id(params[:city])
          session[:result] = @data.results
          erb :favorites_
        end
  end
end
