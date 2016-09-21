module WeatherWeb
  class Cache < ActiveRecord::Base
    self.table_name = "cache"
      def check_if_exist(param)
        time = Time.now
        parse = DataParser.new
        common = WeatherApp::Common.new
        cache = Cache.find_by(:city_id => param)
          if cache.nil?
            weather = common.get_data(city_id)
            parsed = parse.parse_for_database(weather)
            new = Cache.new(:city_name => parsed[0], :city_id => param, :temp => parsed[1].to_s, :weather => parsed[2])
            if new.save
              "Success"
            else
              log = "Error entry is not saved in Cache"
            end
          else
            check_if_updated(cache)
          end
      end

      def check_if_updated(record)
        time = Time.now.to_a
      end
  end
end