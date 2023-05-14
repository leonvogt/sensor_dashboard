require 'rails_helper'

RSpec.describe Sensor::Destroy do
  let!(:device)              { create(:device) }
  let!(:sensor)              { create(:sensor, sensor_type: 'temperature', device: device) }
  let!(:sensor_measurements) { create_list(:sensor_measurement, 10, sensor: sensor) }
  let!(:alarm_rules)         { create_list(:alarm_rule, 2, sensor: sensor) }
  let!(:rule_violations)     { create_list(:rule_violation, 10, alarm_rule: alarm_rules.first) }

  subject { described_class.new(sensor) }

  describe '#destroy_sensor_and_associated_records!' do
    it 'destroys the sensor' do
      expect do
        subject.destroy_sensor_and_associated_records!
      end.to change { Sensor.count }.by(-1)
    end

    it 'destroys associated records' do
      subject.destroy_sensor_and_associated_records!
      expect(SensorMeasurement.count).to eq(0)
      expect(AlarmRule.count).to eq(0)
      expect(RuleViolation.count).to eq(0)
    end
  end
end
