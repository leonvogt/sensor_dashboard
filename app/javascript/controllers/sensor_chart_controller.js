import { Controller } from "@hotwired/stimulus"
import { createChart, updateChart } from '../global/chart_functions'
const  { DateTime }  = require("luxon")

// Connects to data-controller="sensor-chart"
export default class extends Controller {
  connect() {
    this.destroyCharts()

    this.sensorId     = this.element.dataset.sensorId
    this.showDetails  = this.element.dataset.showDetails == 'true'

    // Default Timeframe
    this.currentPeriod = { hours: 24 }
    this.currentTimestampStart = DateTime.local().minus({ hours: 24 }).toSeconds()
    this.currentTimestampEnd = DateTime.now().toSeconds()

    // Chart initial laden
    this.initializeChart().then((charts) => {
      this.charts = charts
    })
  }

  disconnect() {
    this.destroyCharts()
  }

  destroyCharts() {
    this.charts?.forEach((chart) => {
      chart.destroy()
    })
  }

  async initializeChart() {
    // Get Sensor Data
    const sensorData = await this.getSensorData(this.currentTimestampStart, this.currentTimestampEnd)

    let charts = []
    // Generate Chart Data for each Sensor Measurement (temperature, humidity, ...)
    sensorData.forEach((data) => {
      const chartData    = this.sensorChartData(data)
      const chartOptions = this.sensorChartOptions(data)

      console.log(data.value_type);
      console.log(chartData);
      console.log(chartOptions);
      console.log("----------");
      const chartId = `sensor-${this.sensorId}-${data.value_type}`
      charts = [...charts, createChart('line', chartId, { data: chartData, options: chartOptions })]
    })

  }

  async getSensorData(start = this.currentTimestampStart, end = this.currentTimestampEnd) {
    const response  = await fetch(`/sensors/${this.sensorId}.json?timestamp_start=${start}&timestamp_end=${end}`)
    const data      = await response.json()
    return data
  }

  sensorChartData(data) {
    return {
      labels: data.timestamps,
      datasets: [{
        data: data.values,
        tension: 0.4,
        borderWidth: 2,
        pointHoverBackgroundColor: 'rgba(54, 162, 235, 1)',
        segment: {
          borderColor: 'rgba(54, 162, 235, 1)'
        }
      }]
    }
  }

  sensorChartOptions(data) {
    return {
      locale: 'de-DE',
      pointRadius: 0,
      hitRadius: 20,
      hoverRadius: 10,
      scales: {
        x: {
          display: this.showDetails,
          type: 'time',
          ticks: {
            major: {
              enabled: true
            },
            font: (context) => {
              const boldedTicks = context.tick && context.tick.major ? 'bold' : ''
              return { weight: boldedTicks }
            }
          }
        },
        y: {
          ticks: {
            callback: function (value) {
              return value + ' °C'
            }
          },
        }
      },
      plugins: {
        autocolors: false,
        legend: {
          display: false
        },
        tooltip: {
          displayColors: false,
          yAlign: 'bottom',
          callbacks: {
            label: function(context) {
              let label = context.formattedValue || ''
              return label + ' °C'
            }
          }
        }
      }
    }
  }
}
