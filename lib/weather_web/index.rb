module WeatherWeb
  class Index < Sinatra::Base
    attr_accessor :city_str

    def show

    end

    get '/' do
      erb :index
    end

    post '/' do
      @city_str = params[:city]

    end

  end

end