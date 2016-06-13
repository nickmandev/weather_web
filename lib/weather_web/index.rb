module WeatherWeb
  class Index < Sinatra::Base
   enable :sessions
    register Sinatra::StaticAssets
    register Sinatra::Reloader
    set :root => File.dirname(__FILE__)
    set :public_folder => File.join(root + '/public')

    get '/' do
      erb :index
    end

    post '/result' do
      data = WeatherWeb::Data.new
      data.get_city_id(params[:city])
      session[:result] = data.results
      if data.results.length > 1
        redirect ('/multiple_results')
      end
      data.request_data
      erb :result
    end

    get '/multiple_results' do
      session[:result]
      erb :multiple_results
    end

    post '/multiple_results' do
      data = WeatherWeb::Data.new
      data.multiple_results(params[:_id])
      data.request_data
      erb :result
    end


  end

end