class RenameSensorDataToSensorMeasurement < ActiveRecord::Migration[7.0]
  def change
    rename_table :sensor_data, :sensor_measurements
  end
end
