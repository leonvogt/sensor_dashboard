class DestroyDevice
  def initialize(device)
    @device = device
  end

  def destroy_device_and_associated_records!
    Device.transaction do
      destroy_associated_records
      @device.destroy
    end
  end

  private

  def destroy_associated_records
    @device.sensors.each do |sensor|
      Sensor::Destroy.new(sensor).destroy_sensor_and_associated_records!
    end
  end
end
