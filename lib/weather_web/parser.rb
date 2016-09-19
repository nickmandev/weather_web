module WeatherWeb
  class DataParser
    def open_weather(hashes)
      result = []
        hashes.each do |val|
          result.push([val[:name],
          val[:weather][0][:description],
          val[:main][:temp]])
        end
      result
    end
  end
end
