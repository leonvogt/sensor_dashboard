require "rails_helper"

RSpec.describe Sensor::SerializeMeasurements do
  let!(:sensor) { create(:sensor, sensor_type: "temperature") }
  let!(:sensor_measurements) { create_list(:sensor_measurement, 10, sensor: sensor) }

  subject { described_class.new(sensor, sensor_measurements) }

  describe "#serialize" do
    it "returns JSON Object" do
      serialized_data = subject.serialize
      expect(serialized_data).to be_a(Hash)
    end

    it "contains all sensor data" do
      serialized_data = subject.serialize
      expect(serialized_data[:timestamps]).to match_array(sensor_measurements.map(&:created_at))
      expect(serialized_data[:values]).to match_array(sensor_measurements.map(&:value))
    end

    it "contains min, max and avg values" do
      serialized_data = subject.serialize
      expect(serialized_data[:min_value]).to eq(sensor_measurements.map(&:value).min)
      expect(serialized_data[:max_value]).to eq(sensor_measurements.map(&:value).max)
      expect(serialized_data[:avg_value]).to eq(sensor_measurements.map(&:value).sum || 1 / sensor_measurements.count.round(2) || 1)
    end
  end
end
