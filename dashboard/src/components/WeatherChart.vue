<script setup lang="ts">
import { ref, onMounted } from "vue";
import { Chart, registerables } from "chart.js";
import { defineChartComponent } from "vue-chart-3";
import {
  Chart as ChartJS,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";

// Register the required Chart.js components
ChartJS.register(
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement,
  Title,
  Tooltip,
  Legend
);

// Define the Line Chart component
const LineChart = defineChartComponent("test", "line");

// Register Chart.js modules
Chart.register(...registerables);

// Define chart data
const chartData = ref({
  labels: [], // Timestamps
  datasets: [
    {
      label: "Temperature (°C)",
      data: [],
      borderColor: "red",
      backgroundColor: "rgba(255, 99, 132, 0.2)",
      borderWidth: 2,
      tension: 0.4, // Makes the line smooth
    },
    {
      label: "Humidity (%)",
      data: [],
      borderColor: "blue",
      backgroundColor: "rgba(54, 162, 235, 0.2)",
      borderWidth: 2,
      tension: 0.4,
    },
  ],
});

// Fetch weather data from the API
const fetchData = async () => {
  try {
    const response = await fetch("http://weather-console:8080/api/readings", {
      method: "GET",
    });
    const data = await response.json();

    // Update the chart data
    chartData.value.labels = data.map(
      (entry: { timestamp: string | number | Date }) =>
        new Date(entry.timestamp).toLocaleTimeString()
    );
    chartData.value.datasets[0].data = data.map(
      (entry: { temperature: any }) => entry.temperature
    );
    chartData.value.datasets[1].data = data.map(
      (entry: { humidity: any }) => entry.humidity
    );
  } catch (error) {
    console.error("Error fetching data:", error);
  }
};

// 🔄 Poll API every 5 seconds
onMounted(() => {
  fetchData();
  setInterval(fetchData, 5000);
});
</script>

<template>
  <div class="chart-container">
    <h2>📊 Weather Dashboard</h2>
    <LineChart :chart-data="chartData" />
  </div>
</template>

<style scoped>
.chart-container {
  width: 80%;
  margin: auto;
  text-align: center;
}
</style>
