module WeatherWeb
  class Data
      attr_accessor :results, :city_id
      attr_reader :final_result
    def initialize
      @results = []
      @common = WeatherApp::Common.new
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

    def multiple_results

    end

    def response_multiple_results(params)
      params = params - 1
      @city_id = @results[params][:_id]
      request_data
    end

    def single_result
      @city_id = @results[0][:_id]
      request_data
    end

    def request_data
      data = @common.get_data(@city_id)
      @final_result = "The weather in #{data[:name]} is #{data[:weather][0][:description]} and the temperature is #{data[:main][:temp]} C"
    end
  end
end