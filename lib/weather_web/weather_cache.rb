module WeatherWeb
  class WeatherCache < ActiveRecord::Base
    self.table_name = "cache"



    def cache_it(data, city_id)
        parser = DataParser.new
        parsed = parser.single_hash(data)
        new = WeatherCache.create(attributes={city_name: parsed[0], temp: parsed[1], weather: parsed[2], city_id: city_id})
        new.save
        if !save
          parsed
        end

        parsed
    end

    def check_if_updated(record)
        parser = DataParser.new
        common = WeatherApp::Common.new
        cache_record = WeatherCache.find_by(:city_id => record)
        if cache_record.updated_at < 30.minutes.ago
            updated_data = common.get_data(record)
            parsed = parser.single_hash(updated_data)
            puts parsed
            cache_record.update_attributes(:city_name => parsed[0],:temp => parsed[1],:weather => parsed[2])
            parsed_record = parser.cached_result(cache_record)
        else
          parsed_record = parser.cached_result(cache_record)
          puts parsed_record
          parsed_record
        end

    end
  end
end