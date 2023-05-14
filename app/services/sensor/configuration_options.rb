class Sensor::ConfigurationOptions
  CHART_TYPES = ['line', 'bar'].freeze

  SENSOR_TYPE_SUFFIX = {
    'temperature' => '°C',
    'humidity' => '%',
    'pressure' => 'hPa',
    'altitude' => 'm',
    'gas' => 'Ohm',
    'light' => 'Lux',
    'sound' => 'dB',
    'vibration' => 'm/s²',
    'ethanol' => 'ppm',
    'co2' => 'ppm',
    'voc' => 'ppb',
    'tvoc' => 'ppb',
    'ph' => 'pH',
    'ec' => 'µS/cm',
    'frequencies' => 'Hz',
  }.freeze
  SENSOR_TYPES = SENSOR_TYPE_SUFFIX.keys.freeze
end
