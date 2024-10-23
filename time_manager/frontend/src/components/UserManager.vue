<template>
  <div class="user-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Gestion des utilisateurs</h2>

    <!-- Liste des utilisateurs -->
    <ul class="mb-6 space-y-3" v-if="users.length > 0">
      <li v-for="user in users" :key="user.id" class="bg-gray-50 dark:bg-gray-700 p-4 rounded-md shadow flex items-center justify-between transition-all duration-300 hover:shadow-md">
        <div>
          <span class="font-medium text-gray-700 dark:text-gray-200">{{ user.username }}</span>
          <span class="text-gray-500 dark:text-gray-400 ml-2">{{ user.email }}</span>
        </div>
        <div class="space-x-2">
          <button @click="editUser(user)" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">
            <EditIcon class="w-4 h-4 inline-block mr-1" />
            Modifier
          </button>
          <button @click="deleteUser(user.id)" class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50">
            <TrashIcon class="w-4 h-4 inline-block mr-1" />
            Supprimer
          </button>
        </div>
      </li>
    </ul>

    <!-- Formulaire pour ajouter/modifier un utilisateur -->
    <form @submit.prevent="submitUser" class="space-y-4">
      <div class="flex flex-wrap -mx-2">
        <div class="w-full md:w-1/2 px-2 mb-4 md:mb-0">
          <label for="username" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom d'utilisateur</label>
          <input
            id="username"
            v-model="currentUser.username"
            placeholder="Nom d'utilisateur"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
        </div>
        <div class="w-full md:w-1/2 px-2">
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
          <input
            id="email"
            v-model="currentUser.email"
            placeholder="Email"
            type="email"
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
          <UserPlusIcon v-if="!isEditing" class="w-5 h-5 inline-block mr-1" />
          <RefreshCwIcon v-else class="w-5 h-5 inline-block mr-1" />
          {{ isEditing ? 'Mettre à jour' : 'Ajouter' }}
        </button>
      </div>
    </form>
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
    const currentUser = ref({ username: '', email: '' })
    const isEditing = ref(false)

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
        await http.post('/users', {"user": currentUser.value})
        await getUsers()
        currentUser.value.username = "";
		currentUser.value.email = "";
      } catch (error) {
        console.error('Erreur lors de la création de l\'utilisateur:', error)
      }
    }

    async function updateUser() {
      try {
        await http.put(`/users/${currentUser.value.id}`, {"user": {"username": currentUser.value.username, "email": currentUser.value.email} })
        await getUsers()
        currentUser.value = { username: '', email: '' }
        isEditing.value = false
      } catch (error) {
        console.error('Erreur lors de la mise à jour de l\'utilisateur:', error)
      }
    }

    async function deleteUser(id) {
      try {
        await http.delete(`/users/${id}`)
        await getUsers()
      } catch (error) {
        console.error('Erreur lors de la suppression de l\'utilisateur:', error)
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
        // await fetchUsers()
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
