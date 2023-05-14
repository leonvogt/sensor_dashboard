require 'rails_helper'

RSpec.shared_context 'MobileApp requests' do
  def send_request(notification_token: SecureRandom.hex, platform: 'android', app_version: '1.0.0', authentication_token: '121212121212')
    post(
      api_v1_mobile_app_connections_url,
      params: {
        notification_token: notification_token,
        platform: platform,
        app_version: app_version
      },
      headers: {
        'Authorization': "Bearer #{authentication_token}"
      }
    )
    expect(response).to be_successful
  end
end

RSpec.describe 'MobileAppConnection', type: :request do
  let!(:current_user)   { create :user, authentication_token: '121212121212' }

  describe '#create' do
    include_context 'MobileApp requests'

    it 'Creates a MobileAppConnection' do
      expect { send_request }.to change { MobileAppConnection.count }.by(1)
    end

    it 'Renews only the app_version' do
      existing_connection = create :mobile_app_connection, notification_token: '123', app_version: '1.0.0'
      expect {
        send_request(notification_token: '123', app_version: '2.0.0')
      }.to change { existing_connection.reload.app_version }
    end
  end
end
