module WeatherWeb
  class Index < Sinatra::Base
    get '/' do
      'Hello World!'
    end
  end

end