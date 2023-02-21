require 'rails_helper'

RSpec.describe 'Devices', type: :request do
  let!(:user_1)   { create :user }
  let!(:user_2)   { create :user }
  let!(:device_1) { create :device, user: user_1 }
  let!(:device_2) { create :device, user: user_2 }

  before do
    login_as(user_1)
  end

  describe 'GET /index' do
    it 'Only shows the sensors, that the user owns' do
      get devices_path
      expect(response).to be_successful
      expect(response.body).to include(device_1.name)
      expect(response.body).not_to include(device_2.name)
    end
  end

  describe 'GET /show' do
    it 'Shows the sensor, if the user owns it' do
      get devices_path(device_1)
      expect(response).to be_successful
      expect(response.body).to include(device_1.name)
    end

    it 'Does not show the sensor, if the user does not own it' do
      get device_path(device_2)
      expect(response).to redirect_to(root_path)
    end
  end
end
