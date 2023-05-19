require 'rails_helper'

RSpec.describe RuleViolationHandler do
  let!(:device)        { create(:device) }
  let!(:sensor)        { create(:sensor, device: device) }
  let!(:sensor_measurement_0) { create(:sensor_measurement, sensor: sensor, value: 10) }
  let!(:sensor_measurement_1) { create(:sensor_measurement, sensor: sensor, value: 11) }
  let!(:sensor_measurement_2) { create(:sensor_measurement, sensor: sensor, value: 12) }

  let!(:alarm_rule_1)  { create(:alarm_rule, sensor: sensor, rule_type: 'max_value', value: 20) }
  let!(:alarm_rule_2)  { create(:alarm_rule, sensor: sensor, rule_type: 'max_value', value: 30) }

  describe '#check_for_violations!' do
    it "doesn't create violation if all sensor_measurements are alright" do
      expect {
        RuleViolationHandler.new([sensor_measurement_0, sensor_measurement_1, sensor_measurement_2]).check_for_violations!
      }.to_not change { RuleViolation.count }
    end

    it 'creates a violation if a sensor_measurement is outside the allowed range' do
      sensor_measurement_3 = create(:sensor_measurement, sensor: sensor, value: 21)
      expect {
        RuleViolationHandler.new([sensor_measurement_0, sensor_measurement_1, sensor_measurement_2, sensor_measurement_3]).check_for_violations!
      }.to change { RuleViolation.count }.by(1)
    end

    it 'creates multiple violations if multiple sensor_measurements are outside the allowed range' do
      sensor_measurement_3 = create(:sensor_measurement, sensor: sensor, value: 21)
      sensor_measurement_4 = create(:sensor_measurement, sensor: sensor, value: 31)
      expect {
        RuleViolationHandler.new([sensor_measurement_0, sensor_measurement_1, sensor_measurement_2, sensor_measurement_3, sensor_measurement_4]).check_for_violations!
      }.to change { RuleViolation.count }.by(2)
    end

    it 'updates an existing violation if there is already one' do
      RuleViolationHandler.new([create(:sensor_measurement, sensor: sensor, value: 21)]).check_for_violations!
      expect {
        RuleViolationHandler.new([create(:sensor_measurement, sensor: sensor, value: 25)]).check_for_violations!
      }.to change { RuleViolation.last.violation_text }
    end
  end
end
