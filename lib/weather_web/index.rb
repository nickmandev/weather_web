module WeatherWeb
  class Index < Sinatra::Base

     attr_accessor :data, :errors

     register Sinatra::StaticAssets

     register Sinatra::Reloader

     enable :sessions

     enable :logging

     set :root => File.dirname(__FILE__)

     set :public_folder => File.join(root + '/public')

     set :show_exceptions, :after_handler


        get '/' do
          erb :index
        end

        post '/result' do
          @data = WeatherWeb::Data.new
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
          @data = WeatherWeb::Data.new
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
  end
end