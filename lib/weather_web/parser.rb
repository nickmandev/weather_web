module WeatherWeb
  class DataParser
    def multiple_hashes(hashes)
      result = []
      hashes.each do |val|
          result.push([val[:name],
                      val[:main][:temp],
                      val[:weather][0][:description].capitalize])
        end
      result
    end

    def single_hash(hash)
      result = []
      result.push(hash[:name],hash[:main][:temp],hash[:weather][0][:description].capitalize)
      result
    end

    def cached_result(arr)
      result = []
      result.push(arr[:city_name],arr[:temp],arr[:weather].capitalize)
      result
    end
  end
end
