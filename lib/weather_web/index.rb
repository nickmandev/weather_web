module WeatherWeb
  class Index < Sinatra::Base
    attr_accessor :city_str

    def show
      #
    end

    get '/' do
      erb :index
    end

    post '/result' do
      @data = WeatherWeb::Data.new
      @data.get_city_id(params[:city])
    end

    get '/multiple_results' do
      erb :multiple_results
      @data.response_multiple_results(params[:index])
    end
  end

end