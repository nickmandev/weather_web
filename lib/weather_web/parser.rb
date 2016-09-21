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

    def parse_for_database(hash)
      parsed = []
        hash.each do |val|
          parsed.push([val[:name],
          val[:main][:temp],
          val[:weather][0][:description]])
        end
      parsed
    end
  end
end
