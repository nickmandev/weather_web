require_relative 'spec_helper'

describe WeatherWeb::Favorites do
  describe '#forecast_for_favorites' do
    let(:favorites) {WeatherWeb::Favorites.new}

    it 'collect forecast data for favorites' do
      hash = WeatherWeb::Favorites.where(:users_id => '9')
      expect(favorites.forecast_for_favorites(hash).first).to include(:weather)
    end
  end

  describe '#check_if_exist' do
    let(:favorites) {WeatherWeb::Favorites.new}
    let(:curr_usr) {WeatherWeb::User.new(:id => '9')}
    it 'check if record exist in favorites table' do
      params = '727011'
      expect(favorites.check_if_exist(curr_usr,params)).to eql(true)
    end

    it 'must return false if record is not in favorites table' do
      params = '803611'
      expect(favorites.check_if_exist(curr_usr,params)).to eql(false)
    end
  end
end