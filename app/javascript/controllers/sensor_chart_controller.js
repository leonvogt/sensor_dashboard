import { Controller } from "@hotwired/stimulus"
import { createChart } from '../global/chart_functions'
const  { DateTime }  = require("luxon")

// Connects to data-controller="sensor-chart"
export default class extends Controller {
  static targets = ['canvas']

  connect() {
    this.chart?.destroy()

    this.sensorId     = this.element.dataset.sensorId
    this.showDetails  = this.element.dataset.showDetails == 'true'

    // Default Timeframe
    this.currentPeriod = { hours: 24 }
    this.currentTimestampStart = DateTime.local().minus({ hours: 24 }).toSeconds()
    this.currentTimestampEnd = DateTime.now().toSeconds()

    this.initializeChart().then((chart) => {
      this.chart = chart
    })
  }

  disconnect() {
    this.chart?.destroy()
  }

  async initializeChart() {
    const sensorData = await this.getSensorData()

    const chartData    = this.sensorChartData(sensorData)
    const chartOptions = this.sensorChartOptions(sensorData)
    return createChart(sensorData.chart_type, this.canvasTarget.id, { data: chartData, options: chartOptions })
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
      responsive: true,
      maintainAspectRatio: false,
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
              return value + data.value_suffix
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
              return `${label} ${data.value_suffix}`
            }
          }
        }
      }
    }
  }
}
