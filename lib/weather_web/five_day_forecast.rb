module WeatherWeb
  class FiveDayForecast < ActiveRecord::Base
    self.table_name = 'weather'

    def five_day_data(favorites,date)
      ids = []
      results = []
      favorites.each{|fav| ids.push(fav[:city_id])}
      ids.each do |id|
      curr_city = FiveDayForecast.where(timestamp: (date).midnight..(date).end_of_day).where(city_id: id)
      temp_min = temp_max = temp = []
      weather_type = city_id = city_name = ''
        curr_city.each do |city|
          city_name = city[:city_name]
          temp_min.push(city[:temp_min])
          temp_max.push(city[:temp_max])
          temp.push(city[:temp])
          city_id = city[:city_id]
          weather_type = city[:weather_type]
        end
      temp.sort!
      len = temp.length
      hash = Hash.new
      hash[:temp_min] = temp_min.min
      hash[:temp_max] = temp_max.max
      hash[:temp] = (temp[(len-1) / 2] + temp[len / 2]) / 2
      hash[:city_id] = city_id
      hash[:weather_type] = weather_type
      hash[:city_name] = city_name
      results.push(hash)
      end
      results
    end

    def current_day_search
      id = '727011'
      date = Date.today
      five_day_forecast = FiveDayForecast.where(timestamp: date.midnight..date.end_of_day).where(city_id: id)
      puts five_day_forecast
    end
  end
end
