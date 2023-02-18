const Chart = require('chart.js');
import 'chartjs-adapter-luxon';
import zoomPlugin from 'chartjs-plugin-zoom';

Chart.register(zoomPlugin);


export async function createChart(chartType, chartId, chartData){
  const ctx = document.getElementById(chartId).getContext('2d');

  chartConfig = { type: chartType, data: chartData.data, options: chartData.options };
  return new Chart(ctx, chartConfig);
}

// Update labels and Datapoints of a chart
export function updateChart(chart, newLabels, newData, newBorderInfo) {
  chart.data.labels        = [];
  chart.data.datasets.data = [];

  chart.data.labels = newLabels;
  chart.data.datasets.forEach((dataset) => {
    dataset.data = newData
  });

  if (newBorderInfo) {
    chart.options.scales.y.min = newBorderInfo.chartMin
    chart.options.scales.y.max = newBorderInfo.chartMax
  }
  chart.update();
}
