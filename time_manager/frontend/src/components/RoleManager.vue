<template>
  <div class="role-manager bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2">Gestion des rôles et permissions</h2>

    <!-- Formulaire pour ajouter/modifier un rôle -->
    <form @submit.prevent="submitRole" class="mb-8 space-y-4">
      <div class="flex flex-wrap -mx-2">
        <div class="w-full md:w-1/2 px-2 mb-4 md:mb-0">
          <label for="roleName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom du rôle</label>
          <input
            id="roleName"
            v-model="currentRole.name"
            placeholder="Nom du rôle"
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

    <!-- Liste des rôles -->
    <div v-if="roles.length > 0" class="space-y-6">
      <div v-for="role in roles" :key="role.id" class="bg-gray-50 dark:bg-gray-700 p-4 rounded-md shadow">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-xl font-semibold text-gray-800 dark:text-white">{{ role.name }}</h3>
          <div class="space-x-2">
            <button @click="editRole(role)" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">
              <EditIcon class="w-4 h-4 inline-block mr-1" />
              Modifier
            </button>
            <button @click="deleteRole(role.id)" class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50">
              <TrashIcon class="w-4 h-4 inline-block mr-1" />
              Supprimer
            </button>
          </div>
        </div>

        <!-- Liste des permissions du rôle -->
        <div class="mt-4">
          <h4 class="text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Permissions :</h4>
          <ul class="list-disc list-inside space-y-1">
            <li v-for="permission in role.permissions" :key="permission.id" class="text-gray-600 dark:text-gray-400">
              {{ permission.name }}
              <button @click="removePermission(role.id, permission.id)" class="ml-2 text-red-500 hover:text-red-600">
                <XIcon class="w-4 h-4 inline-block" />
              </button>
            </li>
          </ul>
        </div>

        <!-- Ajout de permission -->
        <div class="mt-4 flex items-center">
          <select
            v-model="selectedPermission[role.id]"
            class="flex-grow px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          >
            <option value="">Sélectionner une permission</option>
            <option v-for="permission in availablePermissions(role)" :key="permission.id" :value="permission.id">
              {{ permission.name }}
            </option>
          </select>
          <button @click="addPermission(role.id)" class="ml-2 bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-md transition duration-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-opacity-50">
            <PlusIcon class="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
    <p v-else class="text-gray-500 dark:text-gray-400 text-center mt-4">Aucun rôle n'a été créé pour le moment.</p>

    <!-- Tableau récapitulatif des utilisateurs et leurs rôles -->
    <div class="mt-12">
      <h3 class="text-2xl font-bold mb-4 text-gray-800 dark:text-white">Utilisateurs et leurs rôles</h3>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-800">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Utilisateur</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Rôle</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-900 dark:divide-gray-700">
            <tr v-for="user in users" :key="user.id">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-100">{{ user.username }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{{ user.role ? user.role.name : 'Aucun rôle' }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <select
                  v-model="user.roleId"
                  @change="updateUserRole(user)"
                  class="px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                >
                  <option value="">Aucun rôle</option>
                  <option v-for="role in roles" :key="role.id" :value="role.id">{{ role.name }}</option>
                </select>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { EditIcon, TrashIcon, PlusIcon, RefreshCwIcon, XIcon } from 'lucide-vue-next'
import { http } from '@/api/network/axios'

export default {
  name: 'RoleManager',
  components: {
    EditIcon,
    TrashIcon,
    PlusIcon,
    RefreshCwIcon,
    XIcon
  },
  setup() {
    const roles = ref([])
    const permissions = ref([])
    const users = ref([])
    const currentRole = ref({ name: '' })
    const selectedPermission = ref({})
    const isEditing = ref(false)

    const fetchRoles = async () => {
      try {
        const response = await http.get('/roles')
        roles.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des rôles:', error)
      }
    }

    const fetchPermissions = async () => {
      try {
        const response = await http.get('/permissions')
        permissions.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des permissions:', error)
      }
    }

    const fetchUsers = async () => {
      try {
        const response = await http.get('/users')
        users.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des utilisateurs:', error)
      }
    }

    const submitRole = async () => {
      try {
        if (isEditing.value) {
          await http.put(`/roles/${currentRole.value.id}`, { role: currentRole.value })
        } else {
          await http.post('/roles', { role: currentRole.value })
        }
        currentRole.value = { name: '' }
        isEditing.value = false
        await fetchRoles()
      } catch (error) {
        console.error('Erreur lors de la soumission du rôle:', error)
      }
    }

    const editRole = (role) => {
      currentRole.value = { ...role }
      isEditing.value = true
    }

    const deleteRole = async (roleId) => {
      try {
        await http.delete(`/roles/${roleId}`)
        await fetchRoles()
      } catch (error) {
        console.error('Erreur lors de la suppression du rôle:', error)
      }
    }

    const addPermission = async (roleId) => {
      try {
        await http.post(`/roles/${roleId}/permissions/${selectedPermission.value[roleId]}`)
        await fetchRoles()
      } catch (error) {
        console.error('Erreur lors de l\'ajout de la permission:', error)
      }
    }

    const removePermission = async (roleId, permissionId) => {
      try {
        await http.delete(`/roles/${roleId}/permissions/${permissionId}`)
        await fetchRoles()
      } catch (error) {
        console.error('Erreur lors de la suppression de la permission:', error)
      }
    }

    const updateUserRole = async (user) => {
      try {
        await http.put(`/users/${user.id}`, { user: { role_id: user.roleId } })
        await fetchUsers()
      } catch (error) {
        console.error('Erreur lors de la mise à jour du rôle de l\'utilisateur:', error)
      }
    }

    const availablePermissions = (role) => {
      return permissions.value.filter(p => !role.permissions.some(rp => rp.id === p.id))
    }

    onMounted(() => {
      fetchRoles()
      fetchPermissions()
      fetchUsers()
    })

    return {
      roles,
      permissions,
      users,
      currentRole,
      selectedPermission,
      isEditing,
      submitRole,
      editRole,
      deleteRole,
      addPermission,
      removePermission,
      updateUserRole,
      availablePermissions
    }
  }
}
</script>