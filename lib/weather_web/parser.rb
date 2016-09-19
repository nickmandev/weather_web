module WeatherWeb
  class DataParser

    def open_weather(hashes,hash = {})
      result = []
        hashes.each do |val|
          result.push([val[:name],
          val[:weather][0][:main],
          val[:main][:temp]])
        end
       result
    end
  end
end
