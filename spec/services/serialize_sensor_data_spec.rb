require 'rails_helper'

RSpec.describe SerializeSensorData do
  let!(:sensor) { create(:sensor) }
  let!(:sensor_data) { create_list(:sensor_data, 10, sensor: sensor, value_type: 'temperature') }

  subject { described_class.new(sensor, sensor_data) }

  describe '#serialize' do
    it 'returns JSON Object' do
      serialized_data = subject.serialize
      expect(serialized_data).to be_a(Array)
      expect(serialized_data.first).to be_a(Hash)
    end

    it 'contains all possible values' do
      serialized_data = subject.serialize
      possible_values = SensorTypes::SENSOR_VALUE_TYPES[sensor.sensor_type]
      expect(serialized_data.map { |data| data[:value_type] }).to match_array(possible_values)
    end

    it 'contains all sensor data' do
      serialized_data = subject.serialize
      serialized_timestamps = serialized_data.select { |data| data[:value_type] == 'temperature' }.map { |data| data[:timestamps] }.flatten
      expect(serialized_timestamps).to match_array(sensor_data.map { |data| data.created_at.to_i })

      serialized_values = serialized_data.select { |data| data[:value_type] == 'temperature' }.map { |data| data[:values] }.flatten
      expect(serialized_values).to match_array(sensor_data.map(&:value))
    end

    it 'contains min, max and avg values' do
      serialized_data = subject.serialize
      serialized_min_value = serialized_data.select { |data| data[:value_type] == 'temperature' }.map { |data| data[:min_value] }.flatten
      serialized_max_value = serialized_data.select { |data| data[:value_type] == 'temperature' }.map { |data| data[:max_value] }.flatten
      serialized_avg_value = serialized_data.select { |data| data[:value_type] == 'temperature' }.map { |data| data[:avg_value] }.flatten
      expect(serialized_min_value).to match_array([sensor_data.map(&:value).min])
      expect(serialized_max_value).to match_array([sensor_data.map(&:value).max])
      expect(serialized_avg_value).to match_array([(sensor_data.map(&:value).sum / sensor_data.count).round(2)])
    end
  end
end
