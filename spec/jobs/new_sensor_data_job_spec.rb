require "rails_helper"

describe NewSensorDataJob, type: :job do
  let!(:device)        { create(:device) }
  let!(:sensor)        { create(:sensor, device: device, sensor_type: 'temperature') }
  let!(:alarm_rule)    { create(:alarm_rule, sensor: sensor, rule_type: 'max_value', value: 2) }

  it "Saves sensor data" do
    expect {
      NewSensorDataJob.perform_later(device.id, { temperature: 3 })
    }.to change { SensorData.count }.by(1)
  end

  it "Creates rule violations if necessary" do
    expect {
      NewSensorDataJob.perform_later(device.id, { temperature: 3 })
    }.to change { RuleViolation.count }.by(1)
  end

  describe 'sends notifications' do
    let!(:user) { create(:user) }
    let!(:mobile_app_connection) { create(:mobile_app_connection, user: user, notification_token: 'fexB9TduRH-0O3QDLLKCJB:APA91bH1MMKqtsAAuu6F6Y52RH0M6KONDSzDpSXeYbZKfOMpyK-v8S1253JL4JhkIZLMUX-JcjS_2i42p5E_fH7BwBeb9mOdyxJsKv7QO2eHAGOlD8J3lh5sVtOkh6z2-4RXFRSDOSjj') }

    it 'sends notifications to users with mobile app connections' do
      expect {
        NewSensorDataJob.perform_later(device.id, { temperature: 30 })
      }.to change { Notification.count }.by(1)
    end
  end
end
