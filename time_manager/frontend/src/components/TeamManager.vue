<template>
  <div class="team-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <!-- Navigation par onglets -->
    <div class="mb-6 border-b border-gray-200 dark:border-gray-700">
      <nav class="flex space-x-4">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="currentTab = tab.id"
          :class="[
            'py-2 px-4 text-sm font-medium rounded-t-lg',
            currentTab === tab.id 
              ? 'bg-blue-500 text-white' 
              : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300'
          ]"
        >
          {{ tab.name }}
        </button>
      </nav>
    </div>

    <!-- Contenu des onglets -->
    <div v-if="currentTab === 'teams'" class="teams-management">
      <!-- Formulaire d'ajout d'équipe -->
      <form @submit.prevent="editingTeam ? updateTeam() : createTeam()" class="mb-6">
        <div class="flex gap-4">
          <input 
            v-model="newTeam.name" 
            type="text" 
            :placeholder="editingTeam ? 'Modifier l\'équipe' : 'Nom de l\'équipe'"
            class="flex-1 px-3 py-2 border border-gray-300 rounded-md dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
          <button 
            type="submit"
            :class="[
              'px-4 py-2 text-white rounded-md flex items-center',
              editingTeam ? 'bg-blue-500 hover:bg-blue-600' : 'bg-green-500 hover:bg-green-600'
            ]"
          >
            <PlusIcon v-if="!editingTeam" class="mr-2 h-5 w-5" />
            <EditIcon v-else class="mr-2 h-5 w-5" />
            {{ editingTeam ? 'Modifier l\'équipe' : 'Ajouter une équipe' }}
          </button>
        </div>
      </form>

      <!-- Liste des équipes -->
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <!-- En-têtes du tableau -->
          <thead class="bg-gray-50 dark:bg-gray-800">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                Nom
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                Membres
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <!-- Corps du tableau -->
          <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-900 dark:divide-gray-700">
            <tr v-for="team in teams" :key="team.id">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-100">
                {{ team.name }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">
                {{ team.members_count || 0 }} membres
                <div v-if="team.users && team.users.length > 0" class="text-xs text-gray-400">
                  {{ team.users.map(u => u.username).join(', ') }}
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <button 
                  @click="editTeam(team)"
                  class="text-blue-600 hover:text-blue-900 mr-3"
                >
                  <EditIcon class="h-5 w-5" />
                </button>
                <button 
                  @click="deleteTeam(team.id)"
                  class="text-red-600 hover:text-red-900 mr-3"
                >
                  <TrashIcon class="h-5 w-5" />
                </button>
                <button 
                  @click="openMemberModal(team)"
                  class="text-blue-600 hover:text-blue-900 mr-3"
                >
                  <UsersIcon class="h-5 w-5" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Onglet de pointage existant -->
    <div v-else-if="currentTab === 'clock'" class="clock-management">
      <!-- Votre code existant pour le pointage -->
      <div v-if="selectedTeamId" class="flex justify-center mb-8">
        <button 
          @click="toggleTeamClock" 
          :class="[
            'px-8 py-4 rounded-full text-white font-semibold transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-offset-2',
            isTeamClockIn ? 'bg-red-500 hover:bg-red-600 focus:ring-red-500' : 'bg-green-500 hover:bg-green-600 focus:ring-green-500'
          ]"
        >
          <ClockIcon class="inline-block mr-2 h-6 w-6" />
          {{ isTeamClockIn ? 'Arrêter le travail pour l\'équipe' : 'Commencer le travail pour l\'équipe' }}
        </button>
      </div>

      <!-- Sélection d'équipe -->
      <div class="mb-6">
        <label for="team-select" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Sélectionner une équipe
        </label>
        <select
          id="team-select"
          v-model="selectedTeamId"
          @change="getTeamMembers"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        >
          <option value="">Sélectionner une équipe</option>
          <option v-for="team in teams" :key="team.id" :value="team.id">
            {{ team.name }}
          </option>
        </select>
      </div>

      <!-- Liste des membres de l'équipe -->
      <div v-if="selectedTeamId" class="mt-8">
        <h3 class="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">
          Membres de l'équipe
        </h3>
        <div class="space-y-4">
          <div v-for="member in teamMembers" :key="member.id" 
               class="bg-gray-50 dark:bg-gray-700 p-4 rounded-md shadow flex items-center justify-between">
            <div>
              <span class="text-gray-700 dark:text-gray-200">{{ member.username }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal de gestion des membres -->
    <div v-if="showMemberModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-2xl w-full p-6">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
            Gérer les membres - {{ selectedTeam?.name }}
          </h3>
          <button @click="showMemberModal = false" class="text-gray-500 hover:text-gray-700">
            <XIcon class="h-5 w-5" />
          </button>
        </div>

        <!-- Formulaire d'ajout -->
        <div class="flex gap-2 mb-6">
          <select 
            v-model="selectedUserId"
            class="flex-1 px-3 py-2 border border-gray-300 rounded-md dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          >
            <option value="">Sélectionner un utilisateur</option>
            <option v-for="user in availableUsers" :key="user.id" :value="user.id">
              {{ user.username }}
            </option>
          </select>
          <button 
            @click="addMember"
            class="px-4 py-2 bg-green-500 text-white rounded-md hover:bg-green-600"
          >
            Ajouter
          </button>
        </div>

        <!-- Liste des membres -->
        <div class="space-y-2">
          <div v-for="member in selectedTeam?.users || []" :key="member.id"
               class="flex justify-between items-center p-3 bg-gray-50 dark:bg-gray-700 rounded-md">
            <span class="text-gray-700 dark:text-gray-200">{{ member.username }}</span>
            <button 
              @click="removeMember(member.id)"
              class="text-red-600 hover:text-red-900"
            >
              <TrashIcon class="h-4 w-4" />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ClockIcon, PlusIcon, EditIcon, TrashIcon, UsersIcon, XIcon } from 'lucide-vue-next'
import { http } from '@/api/network/axios'

// État des onglets
const tabs = [
  { id: 'teams', name: 'Gestion des équipes' },
  { id: 'clock', name: 'Pointage d\'équipe' }
]
const currentTab = ref('teams')

// Nouvelles données pour la gestion des équipes
const newTeam = ref({ name: '' })
const editingTeam = ref(null)

// Méthodes de gestion des équipes
const createTeam = async () => {
  try {
    const response = await http.post('/teams', { team: newTeam.value })
    teams.value.push({
      ...response.data.data,
      members: [] // Initialisation des membres
    })
    newTeam.value = { name: '' }
  } catch (error) {
    console.error('Erreur lors de la création de l\'équipe:', error)
  }
}

// Ajouter ces méthodes après createTeam
const editTeam = (team) => {
  editingTeam.value = { ...team }
  newTeam.value = { name: team.name }
}

const updateTeam = async () => {
  try {
    const response = await http.put(`/teams/${editingTeam.value.id}`, {
      team: {
        name: newTeam.value.name
      }
    })
    
    // Mise à jour locale de l'équipe
    const index = teams.value.findIndex(t => t.id === editingTeam.value.id)
    if (index !== -1) {
      teams.value[index] = {
        ...teams.value[index],
        ...response.data.data,
        members: teams.value[index].members || [] // Préserver les membres existants
      }
    }
    
    editingTeam.value = null
    newTeam.value = { name: '' }
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'équipe:', error)
  }
}

const deleteTeam = async (teamId) => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette équipe ?')) return
  
  try {
    await http.delete(`/teams/${teamId}`)
    teams.value = teams.value.filter(team => team.id !== teamId)
  } catch (error) {
    console.error('Erreur lors de la suppression de l\'équipe:', error)
  }
}

const teams = ref([])
const selectedTeamId = ref('')
const teamMembers = ref([])
const isTeamClockIn = ref(false)

// Récupération des équipes
const fetchTeams = async () => {
  try {
    const response = await http.get('/teams')
    console.log('Données reçues du serveur:', response.data)
    
    if (response.data && response.data.data) {
      teams.value = response.data.data.map(team => ({
        id: team.id,
        name: team.name,
        users: Array.isArray(team.users) ? team.users : [],
        members_count: Array.isArray(team.users) ? team.users.length : 0
      }))
    } else {
      teams.value = []
    }
    
    console.log('Teams après traitement:', teams.value)
  } catch (error) {
    console.error('Erreur lors de la récupération des équipes:', error)
    teams.value = []
  }
}

// Récupération des membres de l'équipe et leur statut
const getTeamMembers = async () => {
  if (!selectedTeamId.value) return
  try {
    const response = await http.get(`/teams/${selectedTeamId.value}/members`)
    teamMembers.value = response.data.data
  } catch (error) {
    console.error('Erreur lors de la récupération des membres:', error)
  }
}

// Pointage pour toute l'équipe
const toggleTeamClock = async () => {
  try {
    const response = await http.post(`/teams/${selectedTeamId.value}/clock`)
    isTeamClockIn.value = response.data.status === 'clocked in'
    await getTeamMembers()
  } catch (error) {
    console.error('Erreur lors du pointage d\'équipe:', error)
  }
}

const showMemberModal = ref(false)
const selectedTeam = ref(null)
const availableUsers = ref([])
const selectedUserId = ref('')

// Récupération des utilisateurs disponibles
const fetchAvailableUsers = async () => {
  try {
    const response = await http.get('/users')
    const currentMembers = selectedTeam.value?.users || selectedTeam.value?.members || []
    availableUsers.value = response.data.data.filter(user => 
      !currentMembers.some(member => member.id === user.id)
    )
  } catch (error) {
    console.error('Erreur lors de la récupération des utilisateurs:', error)
  }
}

// Gestion des membres
const openMemberModal = (team) => {
  selectedTeam.value = team
  showMemberModal.value = true
  fetchAvailableUsers()
}

const addMember = async () => {
  if (!selectedUserId.value) return
  try {
    console.log('Ajout membre - ID équipe:', selectedTeam.value.id)
    console.log('Ajout membre - ID utilisateur:', selectedUserId.value)
    
    await http.post(`/teams/${selectedTeam.value.id}/members/${selectedUserId.value}`)
    await fetchTeams()
    
    const updatedTeam = teams.value.find(t => t.id === selectedTeam.value.id)
    console.log('Équipe mise à jour:', updatedTeam)
    
    selectedTeam.value = { ...updatedTeam }
    console.log('État selectedTeam après mise à jour:', selectedTeam.value)
    
    await fetchAvailableUsers()
    selectedUserId.value = ''
  } catch (error) {
    console.error('Erreur lors de l\'ajout du membre:', error)
  }
}

const removeMember = async (userId) => {
  try {
    await http.delete(`/teams/${selectedTeam.value.id}/members/${userId}`)
    await fetchTeams()
  } catch (error) {
    console.error('Erreur lors du retrait du membre:', error)
  }
}

// Cycle de vie
onMounted(() => {
  fetchTeams()
})
</script>



























