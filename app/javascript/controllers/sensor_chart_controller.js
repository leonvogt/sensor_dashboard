import { Controller } from "@hotwired/stimulus"
import { createChart, addDatapointToChart } from '../global/chart_functions'
const  { DateTime }  = require("luxon")

// Connects to data-controller="sensor-chart"
export default class extends Controller {
  static targets = ['canvas', 'resetButton', 'newValueNotifier']

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

  resetChartZoom() {
    this.chart.resetZoom()
    this.hideResetZoomButton()
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

  newValueNotifierTargetConnected(notifier) {
    const formatedTimeLabel = DateTime.fromSeconds(Number(notifier.dataset.timestamp)).toISO()
    addDatapointToChart(this.chart, formatedTimeLabel, notifier.dataset.newValue)
  }

  sensorAlarmRuleLines(data) {
    let lines = { }

    data.alarm_rules.forEach((alarmRule, index) => {
      lines[`line${index}`] = {
        type: 'line',
        borderColor: 'rgba(225, 56, 0, 1)',
        borderWidth: 1,
        borderDash: [0],
        label: {
          display: this.showDetails,
          backgroundColor: 'rgba(225, 56, 0, 0.8)',
          color: 'white',
          content: alarmRule.label,
          font: {
            size: 10
          }
        },
        yMax: alarmRule.value,
        yMin: alarmRule.value,
        yScaleID: 'y',
        xScaleID: 'x'
      }
    })

    return lines
  }

  minMaxAlarmRuleValues(alarm_rules) {
    const alarmRuleValues = alarm_rules.map((alarmRule) => Number(alarmRule.value))
    return { minAlarmRule: Math.round(Math.min(...alarmRuleValues)), maxAlarmRule: Math.round(Math.max(...alarmRuleValues)) }
  }

  minMaxSensorValues(values) {
    const sensorValues = values.map((value) => Number(value))
    return { minSensorValue: Math.round(Math.min(...sensorValues)), maxSensorValue: Math.round(Math.max(...sensorValues)) }
  }

  // Sensor alarm rules should be alway visible.
  // Check if the lowest/highest values are defined by the alarm rules or by the sensor value.
  // Add some space to the lowest/highest values to make the chart little nicer.
  calcMinMaxChartBorder(data) {
    const { minSensorValue, maxSensorValue } = this.minMaxSensorValues(data.values)
    const { minAlarmRule, maxAlarmRule } = this.minMaxAlarmRuleValues(data.alarm_rules)

    const min = minSensorValue < minAlarmRule ? minSensorValue : minAlarmRule
    const max = maxSensorValue > maxAlarmRule ? maxSensorValue : maxAlarmRule

    const space = Math.round(max / 10)
    return { chartMin: min - space, chartMax: max + space }
  }

  sensorChartData(data) {
    return {
      labels: data.timestamps,
      datasets: [{
        data: data.values,
        tension: 0.15,
        borderWidth: 2,
        pointHoverBackgroundColor: 'rgba(54, 162, 235, 1)',
        segment: {
          borderColor: 'rgba(54, 162, 235, 1)'
        }
      }]
    }
  }

  sensorChartOptions(data) {
    let { chartMin, chartMax } = this.calcMinMaxChartBorder(data)

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
          min: chartMin,
          max: chartMax,
          ticks: {
            display: this.showDetails,
            callback: function (value) {
              return value + data.value_suffix
            }
          },
        }
      },
      plugins: {
        annotation: {
          annotations: this.sensorAlarmRuleLines(data)
        },
        zoom: {
          zoom: {
            mode: 'x',
            onZoomStart: () => this.checkZoomValidity(),
            onZoom: () => this.showResetZoomButton(),
            // Maus zum zoomen
            drag: {
              enabled: true,
              backgroundColor: 'rgba(54, 162, 235, 0.2)'
            },
            // Fingergeste zum zoomen
            pinch: {
              enabled: true
            }
          }
        },
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

  checkZoomValidity() {
    const timeStamps        = this.chart.scales.x.ticks.map(tick => tick.value)
    const timeStampStart    = timeStamps[0] / 1000
    const timeStampEnd      = timeStamps[timeStamps.length - 1] / 1000
    const durationInSeconds = timeStampEnd - timeStampStart
    if (durationInSeconds < (60 * 60)) {
      return false
    }
  }

  chartWasZoomed() {

  }

  showResetZoomButton() {
    this.resetButtonTarget.classList.remove('fade-out')
    this.resetButtonTarget.classList.add('fade-in')
  }

  hideResetZoomButton() {
    this.resetButtonTarget.classList.remove('fade-in')
    this.resetButtonTarget.classList.add('fade-out')
  }
}
