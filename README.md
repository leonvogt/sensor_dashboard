# Sensor Dashboard
This Sensor Dashboard is a web application that allows users to view sensor data from a variety of sources. The application is built using Ruby on Rails.

## Installation
1. Install the dependencies:
```bash
bundle install
yarn install
```

2. Create the database:
```bash
rails db:create
rails db:migrate
rails db:seed (optional)
```

3. Make sure redis is installed and running on your system.
```bash
redis-server --daemonize yes
```

To start the webserver, sidekiq, yarn watch and tailwind watch run:
```bash
bin/dev
```

## Sensor list
The following sensors are currently supported:
- [BME280](https://www.adafruit.com/product/2652)
- [CCS811](https://www.adafruit.com/product/3566)
- [CCS811_BME280](https://www.bastelgarage.ch/ccs811-bme280-co2-air-quality-umwelt-sensor)

## Sensor data
The following sensor data is currently supported:
- Temperature
- Humidity
- Pressure
- CO2
- TVOC
