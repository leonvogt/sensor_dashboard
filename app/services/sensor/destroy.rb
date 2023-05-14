class Sensor::Destroy
  def initialize(sensor)
    @sensor = sensor
  end

  def destroy_sensor_and_associated_records!
    Sensor.transaction do
      destroy_associated_records
      @sensor.destroy
    end
  end

  private
  def destroy_associated_records
    # Delete all RuleViolations and SensorMeasurements without callbacks and validations
    # because there could be a lot of them and we don't want to trigger callbacks for each of them.
    RuleViolation.merge(@sensor.rule_violations).delete_all
    @sensor.sensor_measurements.delete_all
  end
end
