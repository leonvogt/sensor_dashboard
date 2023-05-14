# Sensor Dashboard
[![View performance data on Skylight](https://badges.skylight.io/typical/GM3F6Hj9avEh.svg)](https://oss.skylight.io/app/applications/GM3F6Hj9avEh)
[![View performance data on Skylight](https://badges.skylight.io/problem/GM3F6Hj9avEh.svg)](https://oss.skylight.io/app/applications/GM3F6Hj9avEh)

Sensor Dashboard is a web application that allows users to view sensor data from a variety of sources.  
The application is built using Ruby on Rails.  
There is also a [mobile app](https://github.com/leon-vogt/sensor_dashboard_android) in development.

## Data model
The idea is to have devices that have sensors attached to them.
Therefore a device can have multiple sensors that collect data and send it to the server.
Each sensor has a type (like temperature, humidity, pressure, etc.) and can define a chart type (line, bar, etc.).

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

## Sensor Measurement Types
The following sensor measurement types are currently supported:
- Temperature
- Humidity
- Pressure
- CO2
- VOC
- Altitude
- Gas
- Light
- Sound
- Vibration
- Ethanol
- pH
- EC (Conductivity)
- Hz (General frequency)

## API
### External API
Sensor Dashboard provides an public API to send sensor data to the server.    
After creating a device you can create an Access Token, which is used to authenticate the request.

### Internal API
For the Turbo Native mobile app there is an internal API, which is used to get things like the PathConfiguration.
