module WeatherWeb
  class DataParser

    def single_hash(hash)
      result = Hash.new
      result[:name] = hash[:name]
      result[:temp] = hash[:main][:temp]
      result[:weather] = hash[:weather][0][:description].capitalize
      result[:id] = hash[:id]
      result
    end

    def cached_result(arr)
      result = Hash.new
      result[:name] = arr[:city_name]
      result[:temp] = arr[:temp]
      result[:weather] = arr[:weather].capitalize
      result[:id] = arr[:city_id]
      result
    end
  end
end
