module WeatherWeb
  class Index < Sinatra::Base
    enable :sessions

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
    end

    get '/multiple_results' do
      session[:result]
      erb :multiple_results
    end

    post '/multiple_results' do
      data = WeatherWeb::Data.new
      data.multiple_results(params[:_id])
      data.request_data
    end

    get '/single_result' do
      session[:result]
      data = WeatherWeb::Data.new
      data.single_result(session[:result])
      data.request_data
      erb :single_result
    end

  end

end