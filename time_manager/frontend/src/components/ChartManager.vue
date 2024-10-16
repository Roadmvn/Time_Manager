<template>
  <div class="chart-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Graphiques - Heures de travail</h2>

    <!-- Sélecteur d'utilisateur -->
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

    <!-- Sélecteur de type de graphique -->
    <div class="flex flex-wrap gap-4 mb-6">
      <button
        v-for="type in chartTypes"
        :key="type.value"
        @click="changeChartType(type.value)"
        :class="[
          'px-4 py-2 rounded-full transition-all duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-offset-2',
          chartType === type.value ? 'bg-primary text-primary-foreground shadow-md' : 'bg-secondary text-secondary-foreground hover:bg-secondary/80'
        ]"
      >
        {{ type.label }}
      </button>
    </div>

    <!-- Conteneur pour le graphique -->
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

    const chartType = ref('bar'); // Par défaut, on commence avec le graphique à barres
    const chartTypes = [
      { value: 'bar', label: 'Barres' },
      { value: 'pie', label: 'Camembert' }
    ];

    // Récupère la liste des utilisateurs
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

    // Récupère les heures de travail et calcule les heures de jour, de nuit et supplémentaires
    const fetchChartData = async () => {
      if (!selectedUserId.value) {
        console.warn('Aucun utilisateur sélectionné.');
        return;
      }
      try {
        const response = await http.get(`/workingtime/${selectedUserId.value}`);
        if (response.data && response.data.data) {
          chartData.value = response.data.data.map(item => {
            const start = new Date(item.start);
            const end = new Date(item.end);
            const { dayHours, nightHours, overtimeHours } = calculateHours(start, end);

            return {
              date: item.start.split('T')[0],
              day_hours: dayHours,
              night_hours: nightHours,
              overtime_hours: overtimeHours,
            };
          });
          processChartData();
        } else {
          console.error('Les heures de travail n\'ont pas été trouvées dans la réponse:', response);
        }
      } catch (error) {
        console.error('Erreur lors de la récupération des heures de travail:', error);
      }
    };

    // Logique pour calculer les heures de jour, nuit et supplémentaires
    const calculateHours = (start, end) => {
      const NIGHT_START = 22; // Heure de début du travail de nuit (22h)
      const NIGHT_END = 6; // Heure de fin du travail de nuit (6h)
      const MAX_HOURS = 8; // Heures normales avant de considérer les heures supplémentaires

      let totalNightHours = 0;
      let totalDayHours = 0;
      let current = new Date(start);

      while (current < end) {
        const nextHour = new Date(current);
        nextHour.setHours(current.getHours() + 1, 0, 0, 0);

        if (nextHour > end) {
          nextHour.setTime(end.getTime());
        }

        const isNightTime = current.getHours() >= NIGHT_START || current.getHours() < NIGHT_END;
        const hoursWorked = (nextHour - current) / (1000 * 60 * 60);

        if (isNightTime) {
          totalNightHours += hoursWorked;
        } else {
          totalDayHours += hoursWorked;
        }

        current = nextHour;
      }

      const totalHours = totalDayHours + totalNightHours;
      const overtimeHours = totalHours > MAX_HOURS ? totalHours - MAX_HOURS : 0;

      return { dayHours: totalDayHours, nightHours: totalNightHours, overtimeHours };
    };

    // Process les données du graphique
    const processChartData = () => {
      const labels = [];
      const dayHoursData = [];
      const nightHoursData = [];
      const overtimeHoursData = [];
      let totalDayHours = 0;
      let totalNightHours = 0;
      let totalOvertimeHours = 0;

      chartData.value.forEach(entry => {
        labels.push(entry.date);
        dayHoursData.push(entry.day_hours);
        nightHoursData.push(entry.night_hours);
        overtimeHoursData.push(entry.overtime_hours);

        // Ajout aux totaux pour l'affichage du camembert
        totalDayHours += entry.day_hours;
        totalNightHours += entry.night_hours;
        totalOvertimeHours += entry.overtime_hours;
      });

      if (chartType.value === 'pie') {
        updatePieChart(totalDayHours, totalNightHours, totalOvertimeHours);
      } else {
        updateBarChart(labels, dayHoursData, nightHoursData, overtimeHoursData);
      }
    };

    // Mets à jour le graphique à barres
    const updateBarChart = (labels, dayHoursData, nightHoursData, overtimeHoursData) => {
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
              label: 'Heures de jour',
              data: dayHoursData,
              backgroundColor: 'rgba(54, 162, 235, 0.5)',  // Bleu pour les heures de jour
              borderColor: 'rgba(54, 162, 235, 1)',
              borderWidth: 1,
            },
            {
              label: 'Heures de nuit',
              data: nightHoursData,
              backgroundColor: 'rgba(255, 159, 64, 0.5)',  // Orange pour les heures de nuit
              borderColor: 'rgba(255, 159, 64, 1)',
              borderWidth: 1,
            },
            {
              label: 'Heures supplémentaires',
              data: overtimeHoursData,
              backgroundColor: 'rgba(75, 192, 192, 0.5)',  // Vert pour les heures supplémentaires
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
              stacked: true, // Superposer les barres pour un affichage empilé
              title: {
                display: true,
                text: 'Heures',
              },
            },
          },
        },
      });
    };

    // Mets à jour le graphique camembert
    const updatePieChart = (dayHours, nightHours, overtimeHours) => {
      if (chart) {
        chart.destroy();
      }

      const ctx = chartCanvas.value.getContext('2d');
      chart = new Chart(ctx, {
        type: 'pie',
        data: {
          labels: ['Heures de jour', 'Heures de nuit', 'Heures supplémentaires'],
          datasets: [{
            data: [dayHours, nightHours, overtimeHours],
            backgroundColor: [
              'rgba(54, 162, 235, 0.5)',   // Bleu pour les heures de jour
              'rgba(255, 159, 64, 0.5)',   // Orange pour les heures de nuit
              'rgba(75, 192, 192, 0.5)'    // Vert pour les heures supplémentaires
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
    };

    // Fonction pour changer le type de graphique
    const changeChartType = (type) => {
      chartType.value = type;
      if (chartData.value.length) {
        processChartData();
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
      chartTypes,
      changeChartType,
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
