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

    <!-- Recherche -->
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
        </div>
      </div>
    </div>

    <!-- Tableau responsive -->
    <div v-if="!loading && !error && filteredUsers.length > 0">
      <!-- Affichage en tableau pour les écrans moyens et grands -->
      <div class="hidden sm:block">
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
            <template v-for="user in filteredUsers">
              <tr
                v-if="user.role !== 'admin'"
                :key="user.id"
                class="transition-colors duration-200 hover:bg-gray-50 dark:hover:bg-gray-800/50"
                :class="{ 'opacity-50': updatingUsers.includes(user.id) }">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="flex items-center">
                    <div class="h-8 w-8 rounded-full bg-gradient-to-r from-blue-500 to-purple-500 flex items-center justify-center text-white font-medium">
                      {{ user.username.charAt(0).toUpperCase() }}
                    </div>
                    <div class="ml-3">
                      <span class="text-sm font-medium text-gray-900 dark:text-gray-100">{{ user.username }}</span>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span class="text-sm text-gray-500 dark:text-gray-400">{{ user.email }}</span>
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
                </td>
              </tr>
            </template>
          </tbody>
        </table>
      </div>

      <!-- Affichage en cartes pour les petits écrans -->
      <div class="sm:hidden space-y-4">
        <div v-for="user in filteredUsers" :key="user.id" class="bg-gray-50 dark:bg-gray-900 rounded-lg p-4 shadow-md transition-all duration-300 hover:shadow-lg">
          <div class="flex items-center mb-2">
            <div class="h-10 w-10 rounded-full bg-gradient-to-r from-blue-500 to-purple-500 flex items-center justify-center text-white font-medium">
              {{ user.username.charAt(0).toUpperCase() }}
            </div>
            <div class="ml-3">
              <p class="text-lg font-medium text-gray-800 dark:text-gray-100">{{ user.username }}</p>
              <p class="text-sm text-gray-500 dark:text-gray-400">{{ user.email }}</p>
            </div>
          </div>

          <div class="mt-2">
            <p class="text-sm font-semibold text-gray-500 dark:text-gray-400">Rôle actuel :</p>
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
          </div>

          <div class="mt-4">
            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">Changer de rôle :</label>
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
          </div>
        </div>
      </div>
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
  highlightMatch()
})
</script>