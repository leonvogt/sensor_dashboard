require 'rails_helper'

RSpec.describe 'Sensors', type: :request do
  let!(:user_1)   { create :user }
  let!(:user_2)   { create :user }
  let!(:sensor_1) { create :sensor, user: user_1 }
  let!(:sensor_2) { create :sensor, user: user_2 }

  before do
    login_as(user_1)
  end

  describe 'GET /index' do
    it 'Only shows the sensors, that the user owns' do
      get sensors_path
      expect(response).to be_successful
      expect(response.body).to include(sensor_1.name)
      expect(response.body).not_to include(sensor_2.name)
    end
  end

  describe 'GET /show' do
    it 'Shows the sensor, if the user owns it' do
      get sensor_path(sensor_1)
      expect(response).to be_successful
      expect(response.body).to include(sensor_1.name)
    end

    it 'Does not show the sensor, if the user does not own it' do
      get sensor_path(sensor_2)
      expect(response).to redirect_to(root_path)
    end
  end
end
