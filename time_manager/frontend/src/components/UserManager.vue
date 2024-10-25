<template>
  <div class="user-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-8 max-w-4xl mx-auto">
    <!-- Header Section -->
    <div class="relative mb-8">
      <div class="absolute inset-0 rounded-lg -m-2"></div>
      <h2 class="relative text-3xl font-bold text-gray-800 dark:text-white">
        Gestion des utilisateurs
        <span class="block mt-2 text-sm font-normal text-gray-500 dark:text-gray-400">
          Gérez les informations des utilisateurs du système
        </span>
      </h2>
    </div>

    <!-- Formulaire pour ajouter/modifier un utilisateur -->
    <form @submit.prevent="submitUser" class="space-y-4">
      <div class="flex flex-wrap -mx-2">
        <div class="w-full sm:w-1/2 lg:w-1/3 px-2 mb-4">
          <label for="username" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Nom d'utilisateur
          </label>
          <input
            id="username"
            v-model="currentUser.username"
            placeholder="Nom d'utilisateur"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
        </div>
        <div class="w-full sm:w-1/2 lg:w-1/3 px-2 mb-4">
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Email
          </label>
          <input
            id="email"
            v-model="currentUser.email"
            placeholder="Email"
            type="email"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
        </div>
        <div class="w-full lg:w-1/3 px-2">
          <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Mot de passe
            <span v-if="!isEditing" class="text-red-500">*</span>
            <span v-else class="text-xs text-gray-500">(laisser vide pour ne pas modifier)</span>
          </label>
          <input
            id="password"
            v-model="currentUser.password"
            placeholder="Mot de passe"
            type="password"
            :required="!isEditing"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          >
        </div>
      </div>
      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-md transition duration-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-opacity-50 flex items-center space-x-2"
        >
          <UserPlusIcon v-if="!isEditing" class="w-5 h-5" />
          <RefreshCwIcon v-else class="w-5 h-5" />
          <span>{{ isEditing ? 'Mettre à jour' : 'Ajouter' }}</span>
        </button>
      </div>
    </form>

    <!-- Liste des utilisateurs -->
    <ul class="mt-6 space-y-4">
      <li v-for="user in users" :key="user.id" class="flex flex-col sm:flex-row sm:items-center justify-between bg-gray-50 dark:bg-gray-700 p-4 rounded-md shadow transition-all duration-300 hover:shadow-md">
        <div class="flex flex-col sm:flex-row sm:items-center space-y-2 sm:space-y-0 sm:space-x-4">
          <span class="font-medium text-gray-700 dark:text-gray-200">{{ user.username }}</span>
          <span class="text-gray-500 dark:text-gray-400">{{ user.email }}</span>
        </div>
        <div class="flex space-x-2 mt-4 sm:mt-0">
          <button @click="editUser(user)" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 flex items-center space-x-1">
            <EditIcon class="w-4 h-4" />
            <span>Modifier</span>
          </button>
          <button @click="deleteUser(user.id)" class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50 flex items-center space-x-1">
            <TrashIcon class="w-4 h-4" />
            <span>Supprimer</span>
          </button>
        </div>
      </li>
    </ul>
  </div>
</template>


<script>
import { ref, onMounted } from 'vue'
import { EditIcon, TrashIcon, UserPlusIcon, RefreshCwIcon } from 'lucide-vue-next'
import { http } from '@/api/network/axios'

export default {
  name: 'UserManager',
  components: {
    EditIcon,
    TrashIcon,
    UserPlusIcon,
    RefreshCwIcon
  },
  setup() {
    const users = ref([])
    const currentUser = ref({ username: '', email: '', password: '', role: 'user' })
    const isEditing = ref(false)
    const errorMessage = ref('')

    // Validation du mot de passe
    const validatePassword = (password) => {
      if (!password) return false
      const minLength = 8
      const hasUpperCase = /[A-Z]/.test(password)
      const hasLowerCase = /[a-z]/.test(password)
      const hasNumbers = /\d/.test(password)
      return password.length >= minLength && hasUpperCase && hasLowerCase && hasNumbers
    }

    onMounted(() => {
      getUsers()
    })

    async function getUsers() {
      try {
        const response = await http.get('/users')
        users.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des utilisateurs:', error)
      }
    }

    async function createUser() {
      try {
        if (!validatePassword(currentUser.value.password)) {
          errorMessage.value = 'Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre'
          return
        }

        await http.post('/users', {
          user: {
            username: currentUser.value.username,
            email: currentUser.value.email,
            password: currentUser.value.password,
            role: currentUser.value.role // Add the role here
          }
        })
        await getUsers()
        currentUser.value = { username: '', email: '', password: '', role: 'user' } // Reset form with default role
        errorMessage.value = ''
      } catch (error) {
        console.error('Erreur lors de la création de lutilisateur:', error)
        errorMessage.value = 'Erreur lors de la création de lutilisateur'
      }
    }

    async function updateUser() {
      try {
        const userData = {
          username: currentUser.value.username,
          email: currentUser.value.email
        }
        
        if (currentUser.value.password) {
          if (!validatePassword(currentUser.value.password)) {
            errorMessage.value = 'Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre'
            return
          }
          userData.password = currentUser.value.password
        }

        await http.put(`/users/${currentUser.value.id}`, { user: userData })
        await getUsers()
        currentUser.value = { username: '', email: '', password: '', role: 'user' }
        isEditing.value = false
        errorMessage.value = ''
      } catch (error) {
        console.error('Erreur lors de la mise à jour de lutilisateur:', error)
        errorMessage.value = 'Erreur lors de la mise à jour de lutilisateur'
      }
    }

    async function deleteUser(id) {
      try {
        await http.delete(`/users/${id}`)
        await getUsers()
      } catch (error) {
        console.error('Erreur lors de la suppression de lutilisateur:', error)
      }
    }

    function editUser(user) {
      currentUser.value = { ...user }
      isEditing.value = true
    }

    function submitUser() {
      if (isEditing.value) {
        updateUser()
      } else {
        createUser()
      }
    }

    const updateUserRole = async (user, newRole) => {
      try {
        await http.put(`/users/${user.id}/${newRole}`)
      } catch (error) {
        console.error(`Erreur lors de la mise à jour du rôle de l'utilisateur en ${newRole}:`, error)
      }
    }

    const canPromote = (currentUserRole, targetRole) => {
      const roles = ['user', 'manager', 'admin']
      return roles.indexOf(currentUserRole) > roles.indexOf(targetRole)
    }

    return {
      users,
      currentUser,
      isEditing,
      errorMessage,
      getUsers,
      createUser,
      updateUser,
      deleteUser,
      editUser,
      submitUser,
      updateUserRole,
      canPromote
    }
  }
}
</script>
