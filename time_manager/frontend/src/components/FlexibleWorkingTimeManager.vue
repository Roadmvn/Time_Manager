<template>
  <div class="flexible-working-time-manager">
    <h2>Gestion du temps de travail flexible</h2>
    <form @submit.prevent="createFlexibleWorkingTime">
      <input v-model="newWorkingTime.start_time" type="datetime-local" required>
      <input v-model="newWorkingTime.end_time" type="datetime-local" required>
      <button type="submit">Enregistrer</button>
    </form>
    <ul>
      <li v-for="workingTime in flexibleWorkingTimes" :key="workingTime.id">
        <p>Début: {{ formatDate(workingTime.start_time) }}</p>
        <p>Fin: {{ formatDate(workingTime.end_time) }}</p>
        <p>Heures de nuit: {{ workingTime.night_hours }}</p>
        <p>Heures supplémentaires: {{ workingTime.overtime_hours }}</p>
      </li>
    </ul>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import http from '@/http-common'

export default {
  name: 'FlexibleWorkingTimeManager',
  setup() {
    const flexibleWorkingTimes = ref([])
    const newWorkingTime = ref({
      start_time: '',
      end_time: '',
      user_id: 1  // Remplacer par l'ID de l'utilisateur connecté
    })

    const fetchFlexibleWorkingTimes = async () => {
      try {
        const response = await http.get('/flexible_working_times')
        flexibleWorkingTimes.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des temps de travail flexibles:', error)
      }
    }

    const createFlexibleWorkingTime = async () => {
      try {
        await http.post('/flexible_working_times', { flexible_working_time: newWorkingTime.value })
        newWorkingTime.value = { start_time: '', end_time: '', user_id: 1 }
        await fetchFlexibleWorkingTimes()
      } catch (error) {
        console.error('Erreur lors de la création du temps de travail flexible:', error)
      }
    }

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleString()
    }

    onMounted(fetchFlexibleWorkingTimes)

    return {
      flexibleWorkingTimes,
      newWorkingTime,
      createFlexibleWorkingTime,
      formatDate
    }
  }
}
</script>