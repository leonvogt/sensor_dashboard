class Users::RegistrationsController < Devise::RegistrationsController
  def destroy
    # Manually delete all sensor data for the current user
    # Because the default way of `destroy_all` would take too long
    current_user.sensors.each { |sensor| sensor.sensor_measurements.delete_all }
    super
  end
end
