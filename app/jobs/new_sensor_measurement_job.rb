# Saves sensor data and creates rule_violations if necessary.
# If a rule_violation is created, it will send notifications to mobile_app_connections from the user.
# Broadcasts the new sensor data to the view.
class NewSensorMeasurementJob < ApplicationJob
  queue_as :default

  def perform(device_id, sensor_measurements)
    ActiveRecord::Base.transaction do
      device = Device.find(device_id)

      # Save all sensor data from the device
      created_sensor_measurements = Sensor::NewDataHandler.new(device, sensor_measurements).save!

      # Create rule violations if necessary
      rule_violation_handler = RuleViolationHandler.new(device, created_sensor_measurements)
      rule_violation_handler.maybe_create_or_update_violation
      rule_violation_handler.maybe_close_violation
    end
  end
end
