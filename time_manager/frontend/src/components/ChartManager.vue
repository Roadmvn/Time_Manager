<template>
  <div class="chart-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Graphiques - Heures de travail</h2>

    <div class="mb-6">
      <label for="user-select" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Sélectionner un utilisateur</label>
      <select
        id="user-select"
        v-model="selectedUserId"
        @change="fetchChartData"
        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
      >
        <option value="">Sélectionner un utilisateur</option>
        <option v-for="user in users" :key="user.id" :value="user.id">
          {{ user.username }} ({{ user.email }})
        </option>
      </select>
    </div>

    <div class="mb-6">
      <label for="chart-type" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Type de graphique</label>
      <select
        id="chart-type"
        v-model="chartType"
        @change="processChartData"
        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
      >
        <option value="bar">Barres</option>
        <option value="pie">Camembert</option>
      </select>
    </div>

    <div class="flex flex-wrap gap-4 mb-6">
      <button @click="showAllData" class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-4 py-2 rounded-md">Tout</button>
      <button @click="showCurrentMonthData" class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-4 py-2 rounded-md">Ce mois</button>
      <div>
        <label for="start-date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de début</label>
        <input
          id="start-date"
          v-model="startDate"
          type="date"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        />
      </div>
      <div>
        <label for="end-date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de fin</label>
        <input
          id="end-date"
          v-model="endDate"
          type="date"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        />
      </div>
      <button @click="applyDateFilter" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-md">Appliquer le filtre</button>
    </div>

    <div v-if="selectedUserId" class="chart-container bg-gray-50 dark:bg-gray-700 rounded-lg shadow-inner p-4" style="height: 400px;">
      <canvas ref="chartCanvas"></canvas>
    </div>
    <p v-else class="text-gray-500 dark:text-gray-400 text-center mt-4">Veuillez sélectionner un utilisateur pour voir ses graphiques de travail.</p>
  </div>
</template>


<script>
import { ref, onMounted, watch } from 'vue';
import http from '@/api/network/axios';
import Chart from 'chart.js/auto';

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
    let chart = null;

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
        const response = await http.get(`/workingtime/${selectedUserId.value}`);
        if (response.data && response.data.data) {
          chartData.value = response.data.data.map(item => ({
            date: item.start.split('T')[0],
            day_hours: item.day_hours,
            night_hours: item.night_hours,
            overtime_hours: item.overtime_hours,
          }));
          filteredData.value = [...chartData.value]; 
          processChartData();
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
      } else {
        console.warn('Veuillez sélectionner les deux dates.');
      }
    };

    
    const showAllData = () => {
      filteredData.value = [...chartData.value];
      startDate.value = '';
      endDate.value = '';
      processChartData();
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
              backgroundColor: [
                'rgba(54, 162, 235, 0.5)',   
                'rgba(255, 159, 64, 0.5)',   
                'rgba(75, 192, 192, 0.5)'    
              ],
              borderColor: [
                'rgba(54, 162, 235, 1)',
                'rgba(255, 159, 64, 1)',
                'rgba(75, 192, 192, 1)'
              ],
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
                backgroundColor: 'rgba(54, 162, 235, 0.5)', 
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
              },
              {
                label: 'Heures de nuit',
                data: nightHoursData,
                backgroundColor: 'rgba(255, 159, 64, 0.5)', 
                borderColor: 'rgba(255, 159, 64, 1)',
                borderWidth: 1,
              },
              {
                label: 'Heures supplémentaires',
                data: overtimeHoursData,
                backgroundColor: 'rgba(75, 192, 192, 0.5)', 
                borderColor: 'rgba(75, 192, 192, 1)',
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

   
    onMounted(() => {
      getUsers();
    });

    watch(selectedUserId, () => {
      fetchChartData();
    });

    return {
      users,
      selectedUserId,
      chartCanvas,
      chartType,
      startDate,
      endDate,
      showAllData,
      showCurrentMonthData,
      applyDateFilter
    };
  },
};
</script>


<style scoped>
.chart-container {
  height: 400px;
  width: 100%;
}
</style>

