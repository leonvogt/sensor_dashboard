class SensorTypes
  SUPPORTED_SENSORS  = %w[BME280 CCS811 CCS811_BME280]
  SENSOR_VALUE_TYPES = {
    'BME280' => %w[temperature humidity pressure],
    'CCS811' => %w[co2 tvoc],
    'CCS811_BME280' => %w[temperature humidity pressure co2 tvoc]
  }.freeze
end
