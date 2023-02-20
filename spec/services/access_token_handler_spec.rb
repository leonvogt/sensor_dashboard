require 'rails_helper'

RSpec.describe AccessTokenHandler do
  let!(:device) { create(:device) }

  subject { described_class.new }

  describe '#generate_plain_token' do
    it 'generates a new plain access token' do
      first_token  = subject.generate_plain_token
      second_token = subject.generate_plain_token
      expect(first_token).not_to eq(second_token)
    end
  end

  describe '#generate_digest_token' do
    context 'generates a new digest token' do
      it 'same token generates same digest' do
        token  = subject.generate_plain_token
        first_digest  = subject.generate_digest_token(token)
        second_digest = subject.generate_digest_token(token)
        expect(first_digest).to eq(first_digest)
      end

      it 'different token generates different digest' do
        first_digest  = subject.generate_digest_token(subject.generate_plain_token)
        second_digest = subject.generate_digest_token(subject.generate_plain_token)
        expect(first_digest).not_to eq(second_digest)
      end
    end
  end

  describe '#authorize_by_token' do
    it 'finds the device by access token' do
      access_token = subject.generate_plain_token
      device.update!(access_token: subject.generate_digest_token(access_token))
      expect(subject.authorize_by_token(access_token)).to eq(device)
    end
  end
end
