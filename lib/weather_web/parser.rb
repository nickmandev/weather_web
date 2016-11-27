module WeatherWeb
  class DataParser

    def single_hash(hash)
      result = Hash.new
      result[:name] = hash[:name]
      result[:temp] = hash[:main][:temp]
      result[:weather_type] = hash[:weather][0][:description].capitalize
      result[:id] = hash[:id]
      result[:icon] = ''
      add_icon_single(result)
    end

    def cached_result(arr)
      result = Hash.new
      result[:name] = arr[:city_name]
      result[:temp] = arr[:temp]
      result[:weather_type] = arr[:weather].capitalize
      result[:id] = arr[:city_id]
      result[:icon] = ''
      add_icon_single(result)
    end

    def add_icon_single(result)
      icon = 'images/WeatherIcons/' +
          case result[:weather_type]
             when 'Scattered clouds' then 'Cloud.svg'
             when 'Clear' then 'Sun.svg'
             when 'Few clouds' then 'Cloud-Sun.svg'
             when 'Broken clouds' then 'Cloud.svg'
             when 'Shower rain' then 'Cloud-Rain.svg'
             when 'Heavy intensity rain' then 'Cloud-Rain.svg'
             when 'Rain' then 'Cloud-Drizzle-Alt.svg'
             when 'Moderate rain' then 'Cloud-Drizzle-Alt.svg'
             when 'Thunderstorm' then 'Cloud-Lightning.svg'
             when 'Thunderstorm with light rain' then 'Cloud-Lightning.svg'
             when 'Snow' then 'Cloud-Snow-Alt.svg'
             when 'Light rain' then 'Cloud-Rain-Alt.svg'
             when 'Clouds' then 'Cloud.svg'
             when 'Mist' then 'Cloud-Fog.svg'
             when 'Haze' then 'Cloud-Fog-Alt.svg'
             when 'Fog' then 'Cloud-Fog.svg'
             else 'Undefined'
          end
      result[:icon] = icon
      result
    end

    def add_icon_multiple(result)
      result.each do |results|
        puts results
      icon = "images/WeatherIcons/" +
          case results[:weather_type]
            when 'Scattered clouds' then 'Cloud.svg'
            when 'Clear' then 'Sun.svg'
            when 'Few clouds' then 'Cloud-Sun.svg'
            when 'Broken clouds' then 'Cloud.svg'
            when 'Shower rain' then 'Cloud-Rain.svg'
            when 'Heavy intensity rain' then 'Cloud-Rain.svg'
            when 'Rain' then 'Cloud-Drizzle-Alt.svg'
            when 'Moderate rain' then 'Cloud-Drizzle-Alt.svg'
            when 'Thunderstorm' then 'Cloud-Lightning.svg'
            when 'Thunderstorm with light rain' then 'Cloud-Lightning.svg'
            when 'Snow' then 'Cloud-Snow-Alt.svg'
            when 'Light rain' then 'Cloud-Rain-Alt.svg'
            when 'Clouds' then 'Cloud.svg'
            when 'Mist' then 'Cloud-Fog.svg'
            when 'Haze' then 'Cloud-Fog-Alt.svg'
            else 'Undefined'
          end
      results[:icon] = icon
      end
      result
    end
  end
end
