module WeatherWeb
  class WeatherCache < ActiveRecord::Base
    self.table_name = "cache"

    def cache_it(data, city_id)
      parser = DataParser.new
      parsed = parser.single_hash(data)
      new = WeatherCache.create(attributes={
          city_name:  parsed[:name],
          temp:       parsed[:temp],
          weather:    parsed[:weather],
          city_id:    city_id})
      if new[:city_name].nil?
        new.destroy!
        puts "ERROR:Failed save!"
      else
        new.save
      end
      parsed
    end

    def record_from_cache(record)
      parser = DataParser.new
      common = WeatherApp::Common.new
      cache_record = WeatherCache.find_by(:city_id => record)
      parsed_record = parser.cached_result(cache_record)
    end
  end
end
