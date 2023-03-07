require "rails_helper"

describe NewSensorDataJob, type: :job do
  let!(:device)        { create(:device) }
  let!(:sensor)        { create(:sensor, device: device, sensor_type: 'temperature') }

  it "Saves sensor data" do
    expect {
      NewSensorDataJob.perform_later(device.id, {"temperature"=>"3"})
    }.to change { SensorData.count }.by(1)
  end

  it "Creates rule violations if necessary" do
    create :alarm_rule, sensor: sensor, rule_type: 'max_value', value: 2
    expect {
      NewSensorDataJob.perform_later(device.id, {"temperature"=>"3"})
    }.to change { RuleViolation.count }.by(1)
  end
end
