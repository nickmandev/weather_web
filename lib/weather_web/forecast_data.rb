module WeatherWeb
  class ForecastData
      attr_accessor :results

      def initialize
        @results = []
        @common = WeatherApp::Common.new
        @cache = WeatherCache.new
      end

      def get_city_id(params)
        params = params.split.map(&:capitalize).join(" ")
        raise ArgumentError if params.blank?
        @common.get_city_list.each do |val|
          if val[:name] == params
            @results << val
          end
        end

        if @results.length == 1
          single_result
        end
      end

      def multiple_results(params)
        city_id = params.to_i
      end

      def single_result
        city_id = @results.first[:_id]
      end

      def request_data(city_id)
        city_id.to_i
        find = WeatherCache.find_by(:city_id => city_id)
          if find.nil?
            data = @common.get_data(city_id)
            cache_record =  @cache.cache_it(data, city_id)
          else
            value = @cache.record_from_cache(city_id)
          end
      end
  end
end
