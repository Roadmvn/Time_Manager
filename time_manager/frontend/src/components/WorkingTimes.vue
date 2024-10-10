<template>
  <div class="working-times bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Heures de travail</h2>

    <!-- Sélecteur d'utilisateur -->
    <div class="mb-6">
      <label for="user-select" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Sélectionner un utilisateur</label>
      <select
        id="user-select"
        v-model="selectedUserId"
        @change="getWorkingTimes"
        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
      >
        <option value="">Sélectionner un utilisateur</option>
        <option v-for="user in users" :key="user.id" :value="user.id">
          {{ user.username }} ({{ user.email }})
        </option>
      </select>
    </div>

    <!-- Formulaire pour ajouter/modifier des heures de travail -->
    <form @submit.prevent="submitWorkingTime" class="space-y-4 mb-6">
      <div class="flex flex-wrap -mx-2">
        <div class="w-full md:w-1/2 px-2 mb-4 md:mb-0">
          <label for="start-time" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Heure de début</label>
          <input
            id="start-time"
            v-model="currentWorkingTime.start"
            type="datetime-local"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
        </div>
        <div class="w-full md:w-1/2 px-2">
          <label for="end-time" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Heure de fin</label>
          <input
            id="end-time"
            v-model="currentWorkingTime.end"
            type="datetime-local"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
        </div>
      </div>
      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-md transition duration-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-opacity-50"
        >
          <PlusIcon v-if="!isEditing" class="w-5 h-5 inline-block mr-1" />
          <RefreshCwIcon v-else class="w-5 h-5 inline-block mr-1" />
          {{ isEditing ? 'Mettre à jour' : 'Ajouter' }}
        </button>
      </div>
    </form>

    <!-- Liste des heures de travail -->
    <div v-if="selectedUserId">
      <h3 class="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">Plages horaires de travail</h3>
      <ul class="space-y-3">
        <li v-for="time in workingTimes" :key="time.id" class="bg-gray-50 dark:bg-gray-700 p-4 rounded-md shadow flex items-center justify-between transition-all duration-300 hover:shadow-md">
          <span class="text-gray-700 dark:text-gray-200">
            {{ formatDate(time.start) }} - {{ formatDate(time.end) }}
          </span>
          <div class="space-x-2">
            <button @click="editWorkingTime(time)" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">
              <EditIcon class="w-4 h-4 inline-block mr-1" />
              Modifier
            </button>
            <button @click="deleteWorkingTime(time.id)" class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50">
              <TrashIcon class="w-4 h-4 inline-block mr-1" />
              Supprimer
            </button>
          </div>
        </li>
      </ul>
    </div>
    <p v-else class="text-gray-500 dark:text-gray-400 text-center mt-4">Veuillez sélectionner un utilisateur pour voir ses plages horaires de travail.</p>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue'
import { EditIcon, TrashIcon, PlusIcon, RefreshCwIcon } from 'lucide-vue-next'
import { http } from '@/api/network/axios'

export default {
  name: 'WorkingTimes',
  components: {
    EditIcon,
    TrashIcon,
    PlusIcon,
    RefreshCwIcon
  },
  setup() {
    const workingTimes = ref([])
    const currentWorkingTime = ref({ start: '', end: '' })
    const isEditing = ref(false)
    const users = ref([])
    const selectedUserId = ref('')

    onMounted(() => {
      getUsers()
    })

    watch(selectedUserId, (newValue) => {
      if (newValue) {
        getWorkingTimes()
      } else {
        workingTimes.value = []
      }
    })

    async function getUsers() {
      try {
        const response = await http.get('/users')
        users.value = response.data.data
        console.log('Utilisateurs récupérés:', users.value)
      } catch (error) {
        console.error('Erreur lors de la récupération des utilisateurs:', error)
      }
    }

    async function getWorkingTimes() {
      if (!selectedUserId.value) return
      try {
        const response = await http.get(`/workingtime/${selectedUserId.value}`)
        workingTimes.value = response.data.data
        console.log('Heures de travail récupérées:', workingTimes.value)
      } catch (error) {
        console.error('Erreur lors de la récupération des heures de travail:', error)
      }
    }

    async function createWorkingTime() {
      if (!selectedUserId.value) return
      try {
        const response = await http.post(`/workingtime`,
			{"working_time":
				{
					"end": new Date(currentWorkingTime.value.end).toISOString(),
					"start": new Date(currentWorkingTime.value.start).toISOString(),
					"user_id": selectedUserId.value
				}
			})
        const newWorkingTime = response.data.data
        workingTimes.value.push(newWorkingTime)
        currentWorkingTime.value = { start: '', end: '' }
      } catch (error) {
        console.error('Erreur lors de la création des heures de travail:', error)
      }
    }

    async function updateWorkingTime() {
      if (!selectedUserId.value) return
      try {
        const response = await http.put(`/workingTimes/${selectedUserId.value}/${currentWorkingTime.value.id}`, currentWorkingTime.value)
        const updatedWorkingTime = response.data.data // Assurez-vous que c'est le bon chemin pour accéder aux données
        const index = workingTimes.value.findIndex(wt => wt.id === updatedWorkingTime.id)
        if (index !== -1) {
          workingTimes.value[index] = updatedWorkingTime
        }
        currentWorkingTime.value = { start: '', end: '' }
        isEditing.value = false
      } catch (error) {
        console.error('Erreur lors de la mise à jour des heures de travail:', error)
      }
    }

    async function deleteWorkingTime(id) {
      if (!selectedUserId.value) return
      try {
        await http.delete(`/workingTimes/${selectedUserId.value}/${id}`)
        workingTimes.value = workingTimes.value.filter(wt => wt.id !== id)
      } catch (error) {
        console.error('Erreur lors de la suppression des heures de travail:', error)
      }
    }

    function editWorkingTime(time) {
      currentWorkingTime.value = { ...time }
      isEditing.value = true
    }

    function submitWorkingTime() {
      if (isEditing.value) {
        updateWorkingTime()
      } else {
        createWorkingTime()
      }
    }

    function formatDate(dateString) {
      return new Date(dateString).toLocaleString()
    }

    return {
      workingTimes,
      currentWorkingTime,
      isEditing,
      users,
      selectedUserId,
      getUsers,
      getWorkingTimes,
      createWorkingTime,
      updateWorkingTime,
      deleteWorkingTime,
      editWorkingTime,
      submitWorkingTime,
      formatDate
    }
  }
}
</script>