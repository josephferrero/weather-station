<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import VueApexCharts from "vue3-apexcharts";
import { SensorReading } from "@/types";

interface SensorDataPoint {
  x: string;
  y: number;
}

interface SensorData {
  temperature: SensorDataPoint[];
  humidity: SensorDataPoint[];
  pressure: SensorDataPoint[];
  gasResistance: SensorDataPoint[];
  altitude: SensorDataPoint[];
}

const data = ref<SensorReading[]>();
const chartData = ref<SensorData>();

// Fetch weather data from the API
const fetchData = async () => {
  try {
    const response = await fetch("http://weather-console:8080/api/readings", {
      method: "GET",
    });
    data.value = await response.json();
  } catch (error) {
    console.error("Error fetching data:", error);
  }
  if (data.value) {
    chartData.value = transformReadings(data.value);
  }
};

function transformReadings(readings: SensorReading[]): SensorData {
  return readings.reduce<SensorData>(
    (acc, reading) => {
      const {
        timestamp,
        temperature,
        humidity,
        pressure,
        gasResistance,
        altitude,
      } = reading;
      acc.temperature.push({ x: timestamp, y: temperature });
      acc.humidity.push({ x: timestamp, y: humidity });
      acc.pressure.push({ x: timestamp, y: pressure });
      acc.gasResistance.push({ x: timestamp, y: gasResistance });
      acc.altitude.push({ x: timestamp, y: altitude });
      return acc;
    },
    {
      temperature: [],
      humidity: [],
      pressure: [],
      gasResistance: [],
      altitude: [],
    }
  );
}

// Poll API every 5 seconds
onMounted(() => {
  fetchData();
  setInterval(fetchData, 5000);
});

const chartOptions = ref({
  chart: { id: "weather-chart" },
  xaxis: { type: "datetime" },
  // Other chart options...
});

// Make tempSeries reactive using computed
const tempSeries = computed(() => [
  {
    data:
      chartData.value?.temperature?.map((point) => ({
        x: new Date(point.x).getTime(), // convert to milliseconds
        y: point.y,
      })) || [], // fallback to an empty array if no data
  },
]);

// Make tempSeries reactive using computed
const gasResistanceSeries = computed(() => [
  {
    data:
      chartData.value?.gasResistance?.map((point) => ({
        x: new Date(point.x).getTime(), // convert to milliseconds
        y: point.y,
      })) || [], // fallback to an empty array if no data
  },
]);
</script>

<template>
  <div>
    <!-- Check if chartData has been loaded -->
    <div v-if="chartData && chartData.temperature.length">
      <VueApexCharts
        type="line"
        height="350"
        :options="chartOptions"
        :series="tempSeries"
      />
      <VueApexCharts
        type="line"
        height="350"
        :options="chartOptions"
        :series="gasResistanceSeries"
      />
    </div>
    <div v-else>Loading data...</div>
  </div>
</template>
