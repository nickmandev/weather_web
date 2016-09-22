module WeatherWeb
  class ForecastData
      attr_accessor :results

      def initialize
        @results = []
        @common = WeatherApp::Common.new
        @cache = WeatherWeb::Cache.new
      end

      def get_city_id(params)
        params = params.split.map(&:capitalize).join(" ")
        list_of_cities = @common.get_city_list
        list_of_cities.each do |val|
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
        city_id = @results.first._id
      end

      def request_data(city)
        if @cache.find_by(:city_id => city).nil?
          data = @common.get_data(city)
          @cache.check_if_exist(data,city)
          @cache
        else
          @cache.check_if_updated(city)
          @cache
        end
      end
  end
end