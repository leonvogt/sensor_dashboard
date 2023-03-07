require 'rails_helper'

RSpec.shared_context 'MobileApp requests' do
  def send_request(unique_mobile_id: SecureRandom.hex, notification_token: SecureRandom.hex, platform: 'android', app_version: '1.0.0')
    post mobile_app_connections_url, params: {
      mobile_app_connection: {
        unique_mobile_id: unique_mobile_id,
        notification_token: notification_token,
        platform: platform,
        app_version: app_version
      }
    }
    expect(response).to be_successful
  end
end

RSpec.describe 'MobileAppConnection', type: :request do
  let!(:current_user)   { create :user }

  before do
    login_as(current_user)
  end

  describe '#create' do
    include_context 'MobileApp requests'

    it 'Creates a MobileAppConnection' do
      expect { send_request }.to change { MobileAppConnection.count }.by(1)
    end

    it 'Renews only the app_version' do
      existing_connection = create :mobile_app_connection, unique_mobile_id: '123', notification_token: '123', app_version: '1.0.0'
      expect {
        send_request(unique_mobile_id: existing_connection.unique_mobile_id, notification_token: '123', app_version: '2.0.0')
      }.to change { existing_connection.reload.app_version }
    end

    it 'Renews a NotificationToken' do
      existing_connection = create :mobile_app_connection, unique_mobile_id: '123', notification_token: '123'
      expect {
        send_request(unique_mobile_id: existing_connection.unique_mobile_id, notification_token: '456')
      }.to change { existing_connection.reload.notification_token }
    end
  end
end
