module WeatherWeb
  class ForecastData
    attr_accessor :results, :error

    def initialize
      @results = []
      @common = WeatherApp::Common.new
      @cache = WeatherCache.new
      @city_list = CityList.new
    end

    def get_city_id(params)
      params = params.split.map(&:capitalize).join(" ")
      raise ArgumentError if params.blank?
      @results = @city_list.find_city_by_name(params)
      raise StandardError if @results.blank?
      if @results.length == 1
        @results.each{ |city| return city[:city_id]}
      else
        @results
      end
    end

    def multiple_results(params)
      params = params.to_i
    end

    def single_result
      single = @results.first[:_id]
    end

    def request_data(city_id)
      type_forecast = 'weather'
      find = WeatherCache.find_by(:city_id => city_id)
        if find.nil?
          data = @common.get_data(city_id,type_forecast)
          if data[:message] != nil
            raise ArgumentError
          end
          @cache.cache_it(data, city_id)
        else
          @cache.record_from_cache(city_id)
        end
    end
  end
end
