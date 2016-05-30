module WeatherWeb
  class Data
    attr_accessor :results

    def start
      @results = []
      @common = WeatherApp::Common.new
      find_city_id
    end

    def find_city_id
      city = Index.city_str
      city = city.split.map(&:capitalize).join(" ")
      list_of_cities = @common.get_city_list
      list_of_cities.each do |val|
        if val[:name] == city
          @results << val
        end
        @results
      end
    end

    def multiple_results
      @results.each_with_index do |data|
        print index + 1,") #{data[:name]}, #{data[:country]}, - #{data[:coord][:lon]}, #{data[:coord][:lat]}"
      end

    end

    def single_result
      @city_id = @results[0][:_id]
    end
  end
end