module WeatherWeb
  class DataParser

    def single_hash(hash)
      result = []
      result.push(hash[:name],hash[:main][:temp],hash[:weather][0][:description].capitalize,hash[:id])
      result
    end

    def cached_result(arr)
      result = []
      result.push(arr[:city_name],arr[:temp],arr[:weather].capitalize,arr[:city_id])
      result
    end
  end
end
