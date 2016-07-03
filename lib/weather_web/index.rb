module WeatherWeb
  class Index < Sinatra::Base

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

        get '/' do
          erb :index
        end

        post '/result' do
          @data = WeatherWeb::ForecastData.new
          @data.get_city_id(params[:city])
          if params[:city].length == 0
            @errors = "ERROR(Enter a city name) To get back click on Index"
            session[:error] = @errors
            redirect '/error'
          end
          session[:result] = @data.results
          if @data.results.length > 1
            redirect ('/multiple_results')
          end
          if @data.request_data.nil?
            @errors = "There's something wrong with the connection please try again later!"
            session[:error] = @errors
            redirect '/error'
          end
          erb :result
        end

        get '/multiple_results' do
          session[:result]
          erb :multiple_results
        end

        post '/multiple_results' do
          @data = WeatherWeb::ForecastData.new
          @data.multiple_results(params[:_id])
          if @data.request_data.nil?
            @errors = "There's something wrong with the connection please try again later!"
            session[:error] = @errors
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
            redirect '/search'
          end
        end

        get '/favorites' do
          erb :favorites
        end

        post '/favorites' do
          session[:current_user] = cur_usr
          cur_usr.update_attributes('favorites', params[:fav_id])
        end

        post '/favorites_' do
          @data = WeatherWeb::ForecastData.new
          @data.get_city_id(params[:city])
          session[:result] = @data.results
        end
  end
end