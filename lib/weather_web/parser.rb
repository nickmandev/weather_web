module WeatherWeb
  class DataParser

    def single_hash(hash)
      result = Hash.new
      result[:name] = hash[:name]
      result[:temp] = hash[:main][:temp]
      result[:weather] = hash[:weather][0][:description].capitalize
      result[:id] = hash[:id]
        add_icon(result)
    end

    def cached_result(arr)
      result = Hash.new
      result[:name] = arr[:city_name]
      result[:temp] = arr[:temp]
      result[:weather] = arr[:weather].capitalize
      result[:id] = arr[:city_id]
      add_icon(result)
    end

    def add_icon(result)
      icon = "images/WeatherIcons/" +
          case result[:weather]
            when 'Scattered clouds' then 'Cloud.svg'
            when 'Clear sky' then 'Sun.svg'
            when 'Few clouds' then 'Cloud-Sun.svg'
            when 'Broken clouds' then 'Cloud.svg'
            when 'Shower rain' then 'Cloud-Rain.svg'
            when 'Heavy intensity rain' then 'Cloud-Rain.svg'
            when 'Rain' then 'Cloud-Drizzle-Alt.svg'
            when 'Moderate rain' then 'Cloud-Drizzle-Alt.svg'
            when 'Thunderstorm' then 'Cloud-Lightning.svg'
            when 'Snow' then 'Cloud-Snow-Alt.svg'
            when 'Light rain' then 'Cloud-Rain-Alt.svg'
            when 'Overcast clouds' then 'Cloud.svg'
            when 'Mist' then 'Cloud-Fog-Alt.svg'
            else 'Undefined'
          end
      result[:icon] = icon
      result
    end
  end
end
