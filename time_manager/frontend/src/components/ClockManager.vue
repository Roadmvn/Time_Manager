<template>
  <div class="clock-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-md mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Gestion du temps</h2>
    
    <div class="flex flex-col items-center">
      <button 
        @click="toggleClock" 
        :class="[
          'px-6 py-3 rounded-full text-white font-semibold transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-offset-2',
          isClockIn ? 'bg-red-500 hover:bg-red-600 focus:ring-red-500' : 'bg-green-500 hover:bg-green-600 focus:ring-green-500'
        ]"
      >
        <ClockIcon class="inline-block mr-2 h-5 w-5" />
        {{ isClockIn ? 'Arrêter le travail' : 'Commencer le travail' }}
      </button>
      
      <div class="mt-8 text-center">
        <p class="text-xl font-semibold text-gray-700 dark:text-gray-300">
          Statut : 
          <span :class="isClockIn ? 'text-green-500' : 'text-red-500'">
            {{ isClockIn ? 'Au travail' : 'Pas au travail' }}
          </span>
        </p>
        <p v-if="startDateTime" class="mt-2 text-gray-600 dark:text-gray-400">
          Début : {{ formatDate(startDateTime) }}
        </p>
        <p v-if="isClockIn" class="mt-2 text-2xl font-bold text-blue-600 dark:text-blue-400">
          {{ elapsedTime }}
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import axios from 'axios'
import { ClockIcon } from 'lucide-vue-next'

export default {
  name: 'ClockManager',
  components: {
    ClockIcon
  },
  setup() {
    const isClockIn = ref(false)
    const startDateTime = ref(null)
    const userId = ref(1) // À remplacer par l'ID de l'utilisateur connecté
    const elapsedSeconds = ref(0)
    let timer = null

    const elapsedTime = computed(() => {
      const hours = Math.floor(elapsedSeconds.value / 3600)
      const minutes = Math.floor((elapsedSeconds.value % 3600) / 60)
      const seconds = elapsedSeconds.value % 60
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    })

    const startTimer = () => {
      timer = setInterval(() => {
        elapsedSeconds.value++
      }, 1000)
    }

    const stopTimer = () => {
      if (timer) {
        clearInterval(timer)
        timer = null
      }
      elapsedSeconds.value = 0
    }

    const toggleClock = async () => {
      try {
        const response = await axios.post(`/api/clock/${userId.value}`)
        isClockIn.value = response.data.status === 'clocked in'
        startDateTime.value = response.data.start
        if (isClockIn.value) {
          startTimer()
        } else {
          stopTimer()
        }
      } catch (error) {
        console.error('Erreur lors du changement de statut:', error)
      }
    }

    const refresh = async () => {
      try {
        const response = await axios.get(`/api/clock/${userId.value}`)
        isClockIn.value = response.data.status === 'clocked in'
        startDateTime.value = response.data.start
        if (isClockIn.value) {
          const start = new Date(startDateTime.value)
          const now = new Date()
          elapsedSeconds.value = Math.floor((now - start) / 1000)
          startTimer()
        }
      } catch (error) {
        console.error('Erreur lors de la récupération du statut:', error)
      }
    }

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleString()
    }

    onMounted(() => {
      refresh()
    })

    onUnmounted(() => {
      stopTimer()
    })

    return {
      isClockIn,
      startDateTime,
      elapsedTime,
      toggleClock,
      formatDate
    }
  }
}
</script>