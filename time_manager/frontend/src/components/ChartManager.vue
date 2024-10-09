<template>
  <div class="chart-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Graphiques</h2>
    <div class="flex flex-wrap gap-4 mb-6">
      <button
        v-for="type in chartTypes"
        :key="type.value"
        @click="changeChartType(type.value)"
        :class="[
          'px-4 py-2 rounded-full transition-all duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-offset-2',
          chartType === type.value
            ? 'bg-primary text-primary-foreground shadow-md'
            : 'bg-secondary text-secondary-foreground hover:bg-secondary/80'
        ]"
      >
        <component :is="type.icon" class="w-5 h-5 inline-block mr-2" />
        {{ type.label }}
      </button>
    </div>
    <div class="chart-container bg-gray-50 dark:bg-gray-700 rounded-lg shadow-inner p-4" style="height: 400px;">
      <canvas ref="chartCanvas"></canvas>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue'
import axios from 'axios'
import { BarChart3Icon, LineChartIcon, PieChartIcon } from 'lucide-vue-next'
import Chart from 'chart.js/auto'

export default {
  name: 'ChartManager',
  components: {
    BarChart3Icon,
    LineChartIcon,
    PieChartIcon,
  },
  setup() {
    const chartType = ref('bar')
    const chartData = ref(null)
    const userId = ref(1) // À remplacer par l'ID de l'utilisateur connecté
    const chartCanvas = ref(null)
    let chart = null

    const chartTypes = [
      { value: 'bar', label: 'Barre', icon: BarChart3Icon },
      { value: 'line', label: 'Ligne', icon: LineChartIcon },
      { value: 'pie', label: 'Camembert', icon: PieChartIcon },
    ]

    const fetchChartData = async () => {
      try {
        const response = await axios.get(`/api/chartManager/${userId.value}`)
        chartData.value = response.data
        updateChart()
      } catch (error) {
        console.error('Erreur lors de la récupération des données du graphique:', error)
      }
    }

    const updateChart = () => {
      if (!chartData.value) return  // Ajoutez cette ligne pour vérifier si les données sont disponibles

      if (chart) {
        chart.destroy()
      }

      const ctx = chartCanvas.value.getContext('2d')
      chart = new Chart(ctx, {
        type: chartType.value,
        data: {
          labels: chartData.value.map(item => item.name),
          datasets: [{
            label: 'Données',
            data: chartData.value.map(item => item.value),
            backgroundColor: 'rgba(75, 192, 192, 0.6)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false
        }
      })
    }

    const changeChartType = (type) => {
      chartType.value = type
      if (chartData.value) {  // Ajoutez cette condition
        updateChart()
      }
    }

    onMounted(() => {
      fetchChartData()
    })

    watch(chartData, updateChart)

    return {
      chartType,
      chartTypes,
      changeChartType,
      chartCanvas
    }
  }
}
</script>