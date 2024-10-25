<template>
  <div class="chart-manager bg-gradient-to-br from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-900 rounded-xl p-8 max-w-7xl mx-auto shadow-xl">
    <div class="mb-8">
      <h2 class="text-4xl font-bold text-gray-800 dark:text-white">
        Tableau de bord des heures
      </h2>
      <p class="text-gray-600 dark:text-gray-400 mt-2">
        Visualisez et analysez les heures de travail
      </p>
    </div>


    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">

      <div class="space-y-2" v-if="role !== 'user'">
        <label for="user-select" class="text-sm font-semibold text-gray-700 dark:text-gray-300">
          Utilisateur
        </label>
        <select
          id="user-select"
          v-model="selectedUserId"
          @change="fetchChartData"
          class="w-full px-4 py-3 rounded-lg bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all duration-200"
        >
          <option value="">Sélectionner un utilisateur</option>
          <option v-for="user in users" :key="user.id" :value="user.id">
            {{ user.username }} ({{ user.email }})
          </option>
        </select>
      </div>


      <div class="space-y-2">
        <label for="chart-type" class="text-sm font-semibold text-gray-700 dark:text-gray-300">
          Type de visualisation
        </label>
        <select
          id="chart-type"
          v-model="chartType"
          @change="processChartData"
          class="w-full px-4 py-3 rounded-lg bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all duration-200"
        >
          <option value="bar">Graphique en barres</option>
          <option value="pie">Graphique circulaire</option>
        </select>
      </div>
    </div>


    <div class="bg-white dark:bg-gray-800 rounded-lg p-6 mb-8 shadow-md">
  <div class="flex flex-wrap gap-4 items-end">
    <div class="flex gap-3">
      <button
        @click="showAllData"
        class="px-6 py-2.5 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100 dark:bg-blue-900 dark:text-blue-200 dark:hover:bg-blue-800 transition-all duration-200 font-medium"
      >
        Tout
      </button>
      <button
        @click="showCurrentMonthData"
        class="px-6 py-2.5 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100 dark:bg-blue-900 dark:text-blue-200 dark:hover:bg-blue-800 transition-all duration-200 font-medium"
      >
        Ce mois
      </button>
    </div>

    <div class="flex flex-wrap gap-4 items-end w-full md:w-auto">
      <div class="flex-1 min-w-[150px]">
        <label for="start-date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Date de début
        </label>
        <input
          id="start-date"
          v-model="startDate"
          type="date"
          class="w-full px-4 py-2 rounded-lg bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all duration-200"
        />
      </div>
      <div class="flex-1 min-w-[150px]">
        <label for="end-date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Date de fin
        </label>
        <input
          id="end-date"
          v-model="endDate"
          type="date"
          class="w-full px-4 py-2 rounded-lg bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all duration-200"
        />
      </div>
      <div class="flex justify-end w-full md:w-auto">
        <button
          @click="applyDateFilter"
          class="px-6 py-2.5 rounded-lg bg-blue-600 text-white hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600 transition-all duration-200 font-medium"
        >
          Appliquer
        </button>
      </div>
    </div>
  </div>
</div>


    <div v-if="selectedUserId" class="grid grid-cols-1 lg:grid-cols-2 gap-8">

      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 col-span-full">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-white mb-4">Vue d'ensemble des heures</h3>
        <div class="chart-container">
          <canvas ref="chartCanvas"></canvas>
        </div>
      </div>


      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-white mb-4">Top 5 des jours les plus travaillés</h3>
        <div class="chart-container">
          <canvas ref="mostWorkedHoursChart"></canvas>
        </div>
      </div>


      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-white mb-4">Moyenne mensuelle des heures</h3>
        <div class="chart-container">
          <canvas ref="averageMonthlyHoursChart"></canvas>
        </div>
      </div>
    </div>


    <div
      v-else
      class="text-center py-12 bg-white dark:bg-gray-800 rounded-xl shadow-lg"
    >
      <p class="text-gray-500 dark:text-gray-400">
        Veuillez sélectionner un utilisateur pour visualiser ses données
      </p>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watch, computed } from 'vue';
import { http } from "@/api/network/axios";
import Chart from 'chart.js/auto';
import { useAuthStore } from '@/store/auth';

export default {
  name: 'ChartManager',
  setup() {
    const chartData = ref([]);
    const filteredData = ref([]);
    const selectedUserId = ref('');
    const users = ref([]);
    const startDate = ref('');
    const endDate = ref('');
    const chartCanvas = ref(null);
    const mostWorkedHoursChart = ref(null);
    const averageMonthlyHoursChart = ref(null);
    let chart = null;
    let mostWorkedChart = null;
    let averageMonthlyChart = null;
    const authStore = useAuthStore();
    const user = computed(() => authStore.user);
    const role = computed(() => user.value.role);

    const chartType = ref('bar');

    const getUsers = async () => {
      try {
        const response = await http.get('/users');
        if (response.data && response.data.data) {
          users.value = response.data.data;
        } else {
          console.error('Les utilisateurs n\'ont pas été trouvés dans la réponse:', response);
        }
      } catch (error) {
        console.error('Erreur lors de la récupération des utilisateurs:', error);
      }
    };

    const fetchChartData = async () => {
      if (!selectedUserId.value) {
        console.warn('Aucun utilisateur sélectionné.');
        return;
      }
      try {
        const response = await http.get(`/workingtimes/${selectedUserId.value}`);
        if (response.data && response.data.data) {
          chartData.value = response.data.data.map(item => ({
            date: item.start.split('T')[0],
            day_hours: item.day_hours,
            night_hours: item.night_hours,
            overtime_hours: item.overtime_hours,
          }));
          filteredData.value = [...chartData.value];
          processChartData();
          createAdditionalCharts();
        } else {
          console.error('Les heures de travail n\'ont pas été trouvées dans la réponse:', response);
        }
      } catch (error) {
        console.error('Erreur lors de la récupération des heures de travail:', error);
      }
    };

    const applyDateFilter = () => {
      if (startDate.value && endDate.value) {
        filteredData.value = chartData.value.filter(item => {
          return item.date >= startDate.value && item.date <= endDate.value;
        });
        processChartData();
        createAdditionalCharts();
      } else {
        console.warn('Veuillez sélectionner les deux dates.');
      }
    };

    const showAllData = () => {
      filteredData.value = [...chartData.value];
      startDate.value = '';
      endDate.value = '';
      processChartData();
      createAdditionalCharts();
    };

    const showCurrentMonthData = () => {
      const now = new Date();
      const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1).toISOString().split('T')[0];
      const lastDayOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0).toISOString().split('T')[0];

      startDate.value = firstDayOfMonth;
      endDate.value = lastDayOfMonth;

      filteredData.value = chartData.value.filter(item => {
        return item.date >= startDate.value && item.date <= endDate.value;
      });

      processChartData();
      createAdditionalCharts();
    };

    const processChartData = () => {
      const labels = [];
      const dayHoursData = [];
      const nightHoursData = [];
      const overtimeHoursData = [];

      filteredData.value.forEach(entry => {
        labels.push(entry.date);
        dayHoursData.push(entry.day_hours);
        nightHoursData.push(entry.night_hours);
        overtimeHoursData.push(entry.overtime_hours);
      });

      if (chart) {
        chart.destroy();
      }

      const ctx = chartCanvas.value.getContext('2d');


      const colors = {
        day: 'rgba(88, 180, 255, 0.7)',
        night: 'rgba(255, 111, 111, 0.7)',
        overtime: 'rgba(140, 111, 255, 0.7)',
        borderDay: 'rgba(88, 180, 255, 1)',
        borderNight: 'rgba(255, 111, 111, 1)',
        borderOvertime: 'rgba(140, 111, 255, 1)'
      };

      if (chartType.value === 'pie') {
        chart = new Chart(ctx, {
          type: 'pie',
          data: {
            labels: ['Heures de jour', 'Heures de nuit', 'Heures supplémentaires'],
            datasets: [{
              data: [
                dayHoursData.reduce((a, b) => a + b, 0),
                nightHoursData.reduce((a, b) => a + b, 0),
                overtimeHoursData.reduce((a, b) => a + b, 0)
              ],
              backgroundColor: [colors.day, colors.night, colors.overtime],
              borderColor: [colors.borderDay, colors.borderNight, colors.borderOvertime],
              borderWidth: 1,
            }],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
          },
        });
      } else {
        chart = new Chart(ctx, {
          type: 'bar',
          data: {
            labels: labels,
            datasets: [
              {
                label: 'Heures de jour',
                data: dayHoursData,
                backgroundColor: colors.day,
                borderColor: colors.borderDay,
                borderWidth: 1,
              },
              {
                label: 'Heures de nuit',
                data: nightHoursData,
                backgroundColor: colors.night,
                borderColor: colors.borderNight,
                borderWidth: 1,
              },
              {
                label: 'Heures supplémentaires',
                data: overtimeHoursData,
                backgroundColor: colors.overtime,
                borderColor: colors.borderOvertime,
                borderWidth: 1,
              }
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
              x: { stacked: true },
              y: {
                beginAtZero: true,
                stacked: true,
                title: {
                  display: true,
                  text: 'Heures',
                },
              },
            },
          },
        });
      }
    };

    const createAdditionalCharts = () => {
      createMostWorkedHoursChart();
      createAverageMonthlyHoursChart();
    };

    const createMostWorkedHoursChart = () => {
      const sortedData = [...filteredData.value].sort((a, b) =>
        (b.day_hours + b.night_hours + b.overtime_hours) - (a.day_hours + a.night_hours + a.overtime_hours)
      ).slice(0, 5);

      const labels = sortedData.map(item => item.date);
      const workedHours = sortedData.map(item => item.day_hours + item.night_hours + item.overtime_hours);

      if (mostWorkedChart) mostWorkedChart.destroy();
      const ctx = mostWorkedHoursChart.value.getContext('2d');
      mostWorkedChart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: 'Heures travaillées',
            data: workedHours,
            backgroundColor: 'rgba(255, 111, 111, 0.5)',
            borderColor: 'rgba(255, 111, 111, 1)',
            borderWidth: 1,
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          indexAxis: 'y',
          scales: {
            x: {
              beginAtZero: true,
              display: false,
            },
            y: {
              display: false,
            }
          }
        }
      });
    };

    const createAverageMonthlyHoursChart = () => {
      const monthlyData = {};

      filteredData.value.forEach(entry => {
        const month = entry.date.slice(0, 7); // Mois (YYYY-MM)
        if (!monthlyData[month]) monthlyData[month] = 0;
        monthlyData[month] += entry.day_hours + entry.night_hours + entry.overtime_hours;
      });

      const labels = Object.keys(monthlyData);
      const averages = Object.values(monthlyData).map(total => total / labels.length);

      if (averageMonthlyChart) averageMonthlyChart.destroy();
      const ctx = averageMonthlyHoursChart.value.getContext('2d');
      averageMonthlyChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: 'Moyenne d\'heures travaillées',
            data: averages,
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1,
          }]
        },
        options: { responsive: true, maintainAspectRatio: false }
      });
    };


    onMounted(() => {
        if (role.value === "user") {
            selectedUserId.value = user.value.id;
            fetchChartData();
        } else {
            getUsers();
        }
    });

    watch(selectedUserId, () => {
      fetchChartData();
    });

    return {
      users,
      selectedUserId,
      chartCanvas,
      mostWorkedHoursChart,
      averageMonthlyHoursChart,
      chartType,
      startDate,
      endDate,
      showAllData,
      showCurrentMonthData,
      applyDateFilter,
      user,
      role
    };
  },
};
</script>

<style scoped>
.chart-container {
  height: 400px;
  width: 100%;
}


canvas {
  backdrop-filter: blur(8px);
  transition: all 0.3s ease;
}
</style>
