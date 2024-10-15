<template>
  <div class="night-shift-manager">
    <h2>Gestion des équipes de nuit</h2>
    <form @submit.prevent="createNightShift">
      <input v-model="newShift.shift_date" type="date" required>
      <button type="submit">Enregistrer</button>
    </form>
    <ul>
      <li v-for="shift in nightShifts" :key="shift.id">
        <p>Date: {{ shift.shift_date }}</p>
        <p>Nuits consécutives: {{ shift.consecutive_nights }}</p>
        <p v-if="shift.consecutive_nights >= 3" class="alert">Alerte: Maximum de nuits consécutives atteint!</p>
      </li>
    </ul>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import http from '@/http-common'

export default {
  name: 'NightShiftManager',
  setup() {
    const nightShifts = ref([])
    const newShift = ref({
      shift_date: '',
      user_id: 1  // Remplacer par l'ID de l'utilisateur connecté
    })

    const fetchNightShifts = async () => {
      try {
        const response = await http.get('/night_shifts', { params: { user_id: 1 } })
        nightShifts.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des équipes de nuit:', error)
      }
    }

    const createNightShift = async () => {
      try {
        await http.post('/night_shifts', { night_shift: newShift.value })
        newShift.value = { shift_date: '', user_id: 1 }
        await fetchNightShifts()
      } catch (error) {
        console.error('Erreur lors de la création de l\'équipe de nuit:', error)
      }
    }

    onMounted(fetchNightShifts)

    return {
      nightShifts,
      newShift,
      createNightShift
    }
  }
}
</script>

<style scoped>
.alert {
  color: red;
  font-weight: bold;
}
</style>