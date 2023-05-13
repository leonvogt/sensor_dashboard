class DestroyDevice
  def initialize(device)
    @device = device
  end

  def destroy!
    Device.transaction do
      destroy_associated_records
      @device.destroy
    end
  end

  private
  def destroy_associated_records
    @device.sensors.each do |sensor|
      # Delete all RuleViolations and SensorData without callbacks,
      # because there could be a lot of them and we don't want to
      # trigger callbacks for each of them.
      RuleViolation.merge(sensor.rule_violations).delete_all
      sensor.sensor_data.delete_all

      sensor.destroy
    end
  end
end
