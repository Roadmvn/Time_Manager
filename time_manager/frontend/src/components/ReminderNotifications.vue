<template>
  <div class="reminder-notifications">
    <h2>Rappels de pointage</h2>
    <ul>
      <li v-for="reminder in reminders" :key="reminder.id">
        {{ reminder.message }} - {{ formatDate(reminder.sent_at) }}
      </li>
    </ul>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import http from '@/http-common'

export default {
  name: 'ReminderNotifications',
  setup() {
    const reminders = ref([])

    const fetchReminders = async () => {
      try {
        const response = await http.get('/reminders', { params: { user_id: 1 } }) // Remplacer par l'ID de l'utilisateur connecté
        reminders.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des rappels:', error)
      }
    }

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleString()
    }

    onMounted(fetchReminders)

    return {
      reminders,
      formatDate
    }
  }
}
</script>