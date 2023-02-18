require 'rails_helper'

RSpec.describe Sensor, type: :model do
  subject { create(:sensor) }

  # describe '#generate_access_token' do
  #   it 'generates a new access token' do
  #     expect {
  #       subject.generate_access_token
  #     }.to change(subject, :access_token)
  #   end
  # end
end
