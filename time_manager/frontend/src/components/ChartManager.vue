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

  
    <div v-if="selectedUserId" class="chart-container bg-gray-50 dark:bg-gray-700 rounded-lg shadow-inner p-4" style="height: 400px;">
      <canvas ref="chartCanvas"></canvas>
    </div>
    <p v-else class="text-gray-500 dark:text-gray-400 text-center mt-4">Veuillez sélectionner un utilisateur pour voir ses graphiques de travail.</p>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue';
import { http } from '@/api/network/axios'; 
import Chart from 'chart.js/auto';

export default {
  name: 'ChartManager',
  setup() {
    const chartData = ref([]);
    const selectedUserId = ref('');
    const users = ref([]);
    const chartCanvas = ref(null);
    let chart = null;

    const getUsers = async () => {
      try {
        const response = await http.get('/users');
        if (response.data && response.data.data) {
          users.value = response.data.data;
          console.log('Utilisateurs récupérés:', users.value);
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
            start: new Date(item.start),
            end: new Date(item.end),
          }));
          processChartData();
        } else {
          console.error('Les heures de travail n\'ont pas été trouvées dans la réponse:', response);
        }
      } catch (error) {
        console.error('Erreur lors de la récupération des heures de travail:', error);
      }
    };

    
    const processChartData = () => {
      const totalHoursPerDay = {};

      chartData.value.forEach(entry => {
        const day = entry.date;
        const hoursWorked = (entry.end - entry.start) / (1000 * 60 * 60); // Calculate hours worked

        if (totalHoursPerDay[day]) {
          totalHoursPerDay[day] += hoursWorked;
        } else {
          totalHoursPerDay[day] = hoursWorked;
        }
      });

      const labels = Object.keys(totalHoursPerDay);
      const data = Object.values(totalHoursPerDay);

      updateChart(labels, data);
    };

    
    const updateChart = (labels, data) => {
      if (chart) {
        chart.destroy();
      }

      const ctx = chartCanvas.value.getContext('2d');
      chart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [
            {
              label: 'Heures de travail',
              data: data,
              backgroundColor: 'rgba(54, 162, 235, 0.5)',
              borderColor: 'rgba(54, 162, 235, 1)',
              borderWidth: 1,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Heures',
              },
            },
          },
        },
      });
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
