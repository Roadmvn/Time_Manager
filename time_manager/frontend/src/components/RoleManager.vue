<template>
  <div class="role-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-8 max-w-4xl mx-auto">
    
    <div class="relative mb-8">
      <div class="absolute inset-0 bg-gradient-to-r from-blue-500/10 to-purple-500/10 rounded-lg -m-2"></div>
      <h2 class="relative text-3xl font-bold text-gray-800 dark:text-white">
        Gestion des rôles
        <span class="block mt-2 text-sm font-normal text-gray-500 dark:text-gray-400">
          Gérez les permissions des utilisateurs
        </span>
      </h2>
    </div>
    
    <div class="mb-8">
      <div class="flex flex-col md:flex-row gap-4">
        <div class="flex-1 group">
          <div class="relative transition-all duration-300 rounded-lg">
            <input
              type="text"
              v-model="searchQuery"
              placeholder="Rechercher par email ou nom d'utilisateur..."
              class="w-full px-4 py-3 pl-12 pr-4 border-2 border-gray-200 rounded-lg shadow-sm 
                     transition-all duration-300 ease-in-out
                     focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500
                     dark:bg-gray-700 dark:border-gray-600 dark:text-white
                     group-hover:border-blue-500/50"
              @input="handleSearch"
            />
            <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 transition-transform duration-300 group-hover:scale-110">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </span>
          </div>
          
          <transition
            enter-active-class="transition ease-out duration-200"
            enter-from-class="opacity-0 transform -translate-y-2"
            enter-to-class="opacity-100 transform translate-y-0"
            leave-active-class="transition ease-in duration-150"
            leave-from-class="opacity-100 transform translate-y-0"
            leave-to-class="opacity-0 transform -translate-y-2"
          >
            <div v-if="searchQuery" class="mt-2 text-sm text-gray-500 dark:text-gray-400 flex items-center gap-2">
              <span class="flex items-center gap-1">
                <span class="w-2 h-2 rounded-full bg-blue-500"></span>
                {{ filteredUsers.length }} résultat(s) trouvé(s)
              </span>
              <span class="text-gray-400">pour "{{ searchQuery }}"</span>
            </div>
          </transition>
        </div>
      </div>
    </div>

    <transition
      enter-active-class="transition-opacity duration-300"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-300"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="loading" class="flex justify-center items-center py-12">
        <div class="relative">
          <div class="animate-spin rounded-full h-12 w-12 border-4 border-blue-500/20"></div>
          <div class="absolute top-0 left-0 animate-spin rounded-full h-12 w-12 border-t-4 border-blue-500"></div>
        </div>
      </div>
    </transition>

    <transition
      enter-active-class="transition-all duration-300"
      enter-from-class="opacity-0 transform -translate-y-4"
      enter-to-class="opacity-100 transform translate-y-0"
      leave-active-class="transition-all duration-200"
      leave-from-class="opacity-100 transform translate-y-0"
      leave-to-class="opacity-0 transform -translate-y-4"
    >
      <div v-if="error" class="bg-red-50 dark:bg-red-900/20 border-l-4 border-red-500 p-4 rounded-r-lg mb-6" role="alert">
        <div class="flex items-center gap-3">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
          <div>
            <p class="font-medium text-red-800 dark:text-red-200">Erreur!</p>
            <p class="text-sm text-red-700 dark:text-red-300">{{ error }}</p>
          </div>
        </div>
      </div>
    </transition>

    <transition
      enter-active-class="transition-all duration-300"
      enter-from-class="opacity-0 scale-95"
      enter-to-class="opacity-100 scale-100"
      leave-active-class="transition-all duration-200"
      leave-from-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-95"
    >
      <div v-if="!loading && !error && filteredUsers.length === 0" 
           class="text-center py-12 px-4 rounded-lg bg-gray-50 dark:bg-gray-800/50">
        <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-16 w-16 text-gray-400 dark:text-gray-500 mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p class="text-xl font-medium text-gray-700 dark:text-gray-300">Aucun utilisateur trouvé</p>
        <p class="mt-2 text-gray-500 dark:text-gray-400">Essayez de modifier vos critères de recherche</p>
      </div>
    </transition>

    <div v-if="!loading && !error && filteredUsers.length > 0" class="overflow-hidden rounded-lg border border-gray-200 dark:border-gray-700">
      <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
        <thead class="bg-gray-50 dark:bg-gray-800/50">
          <tr>
            <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Utilisateur
            </th>
            <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Email
            </th>
            <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Rôle actuel
            </th>
            <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Actions
            </th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-900 dark:divide-gray-700">
          <tr v-for="user in filteredUsers" 
              :key="user.id" 
              class="transition-colors duration-200 hover:bg-gray-50 dark:hover:bg-gray-800/50"
              :class="{ 'opacity-50': updatingUsers.includes(user.id) }">
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="flex items-center">
                <div class="h-8 w-8 rounded-full bg-gradient-to-r from-blue-500 to-purple-500 flex items-center justify-center text-white font-medium">
                  {{ user.username.charAt(0).toUpperCase() }}
                </div>
                <div class="ml-3">
                  <span class="text-sm font-medium text-gray-900 dark:text-gray-100" v-html="highlightMatch(user.username)"></span>
                </div>
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="text-sm text-gray-500 dark:text-gray-400" v-html="highlightMatch(user.email)"></span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="px-3 py-1 text-xs font-semibold rounded-full inline-flex items-center gap-1"
                :class="{
                  'bg-blue-100 text-blue-800 dark:bg-blue-900/50 dark:text-blue-300': user.role === 'user',
                  'bg-green-100 text-green-800 dark:bg-green-900/50 dark:text-green-300': user.role === 'manager'
                }">
                <span class="w-1.5 h-1.5 rounded-full"
                  :class="{
                    'bg-blue-500': user.role === 'user',
                    'bg-green-500': user.role === 'manager'
                  }">
                </span>
                {{ formatRole(user.role) }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="relative">
                <select
                  :value="user.role"
                  @change="(e) => updateUserRole(user, e.target.value)"
                  :disabled="updatingUsers.includes(user.id)"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm
                         transition-colors duration-200
                         focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500
                         dark:bg-gray-700 dark:border-gray-600 dark:text-white
                         disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <option v-for="role in availableRoles" :key="role.value" :value="role.value">
                    {{ role.label }}
                  </option>
                </select>
                <transition
                  enter-active-class="transition-opacity duration-200"
                  enter-from-class="opacity-0"
                  enter-to-class="opacity-100"
                  leave-active-class="transition-opacity duration-200"
                  leave-from-class="opacity-100"
                  leave-to-class="opacity-0"
                >
                  <div v-if="updatingUsers.includes(user.id)" 
                       class="absolute right-2 top-1/2 transform -translate-y-1/2">
                    <div class="animate-spin rounded-full h-4 w-4 border-2 border-blue-500 border-t-transparent"></div>
                  </div>
                </transition>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>


<script setup>
import { ref, computed, onMounted } from 'vue'
import { http } from '@/api/network/axios'
import debounce from 'lodash/debounce'

const users = ref([])
const loading = ref(true)
const error = ref(null)
const updatingUsers = ref([])
const searchQuery = ref('')

const availableRoles = [
  { value: 'user', label: 'Utilisateur' },
  { value: 'manager', label: 'Manager' }
]

const filteredUsers = computed(() => {
  if (!searchQuery.value) return users.value
  
  const query = searchQuery.value.toLowerCase().trim()
  return users.value.filter(user => 
    user.username.toLowerCase().includes(query) ||
    user.email.toLowerCase().includes(query)
  )
})

const highlightMatch = (text) => {
  if (!searchQuery.value) return text
  
  const query = searchQuery.value.toLowerCase()
  const index = text.toLowerCase().indexOf(query)
  
  if (index === -1) return text
  
  return text.slice(0, index) +
    `<span class="bg-yellow-200 dark:bg-yellow-600">${text.slice(index, index + query.length)}</span>` +
    text.slice(index + query.length)
}

const formatRole = (role) => {
  const roleMap = {
    'user': 'Utilisateur',
    'manager': 'Manager'
  }
  return roleMap[role] || role
}

const handleSearch = debounce(() => {
}, 300)

const fetchUsers = async () => {
  loading.value = true
  error.value = null
  
  try {
    const response = await http.get('/users')
    users.value = response.data.data
  } catch (err) {
    error.value = 'Impossible de charger les utilisateurs. Veuillez réessayer plus tard.'
    console.error('Erreur lors de la récupération des utilisateurs:', err)
  } finally {
    loading.value = false
  }
}

const updateUserRole = async (user, newRole) => {
  if (user.role === newRole) return
  
  updatingUsers.value.push(user.id)
  
  try {
    await http.put(`/users/${user.id}`, {
      user: { role: newRole }
    })
    
    const userIndex = users.value.findIndex(u => u.id === user.id)
    if (userIndex !== -1) {
      users.value[userIndex] = { ...users.value[userIndex], role: newRole }
    }
    
  } catch (err) {
    error.value = `Erreur lors de la mise à jour du rôle pour ${user.username}`
    console.error('Erreur lors de la mise à jour du rôle:', err)
    await fetchUsers() // Revert to server state
  } finally {
    updatingUsers.value = updatingUsers.value.filter(id => id !== user.id)
  }
}

onMounted(() => {
  fetchUsers()
})
</script>