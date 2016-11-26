module WeatherWeb
  class CityList < ActiveRecord::Base
    self.table_name = "city_list"

    def find_city_by_name(param)
      record = CityList.where(city_name: param.split.map(&:capitalize).join(" "))
    end
  end
end