module WeatherWeb
  class DataParser

    def flatt_hash(hash,old_path = [],result = {})
      return result.update({old_path => hash}) unless hash.is_a?(Hash)
      hash.each {|key,val| flatt_hash(val,old_path + [key],result)}
      result
      puts result
    end

    def open_weather(array)

    end
  end
end
