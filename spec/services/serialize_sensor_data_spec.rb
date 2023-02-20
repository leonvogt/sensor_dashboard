require 'rails_helper'

RSpec.describe SerializeSensorData do
  let!(:sensor)      { create(:sensor, sensor_type: 'temperature') }
  let!(:sensor_data) { create_list(:sensor_data, 10, sensor: sensor) }

  subject { described_class.new(sensor, sensor_data) }

  describe '#serialize' do
    it 'returns JSON Object' do
      serialized_data = subject.serialize
      expect(serialized_data).to be_a(Hash)
    end

    it 'contains all sensor data' do
      serialized_data       = subject.serialize

      expect(serialized_data[:timestamps]).to match_array(sensor_data.map(&:created_at).map(&:to_i))
      expect(serialized_data[:values]).to match_array(sensor_data.map(&:value))
    end

    it 'contains min, max and avg values' do
      serialized_data = subject.serialize
      expect(serialized_data[:min_value]).to eq(sensor_data.map(&:value).min)
      expect(serialized_data[:max_value]).to eq(sensor_data.map(&:value).max)
      expect(serialized_data[:avg_value]).to eq((sensor_data.map(&:value).sum / sensor_data.count).round(2))
    end
  end
end
