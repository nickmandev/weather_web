module WeatherWeb
  class Cache < ActiveRecord::Base
    self.table_name = "cache"
      def check_if_exist(data,city_id)
        parsed = parse.single_hash(data)
        new = Cache.create(attributes={city_name: parsed[0],temp: parsed[1], weather: parsed[2], city_id: city_id})
        new.save
        if !save
          parsed
        end
        new
      end

      def check_if_updated(record)
        common = WeatherApp::Common.new
        time = Time.now.to_a
        parser = WeatherWeb::DataParser.new
        cache_record = Cache.find_by(:city_id => record)
        puts cache_record
        if cache_record.updated_at < 30.minutes.ago
            updated_data = common.get_data(record)
            parsed = parser.single_hash(updated_data)
            cache_record.update_attributes(:city_name => parsed[0],:temp => parsed[1],:weather => parsed[2])
            puts cache_record
        else
            parsed = parser.cached_result(cache_record)
            puts parsed
        end
      end
  end
end