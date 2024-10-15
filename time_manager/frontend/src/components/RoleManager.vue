<template>
  <div class="role-manager">
    <h2>Gestion des rôles et permissions</h2>
    <form @submit.prevent="createRole">
      <input v-model="newRole.name" placeholder="Nom du rôle" required>
      <button type="submit">Créer un rôle</button>
    </form>
    <ul>
      <li v-for="role in roles" :key="role.id">
        {{ role.name }}
        <ul>
          <li v-for="permission in role.permissions" :key="permission.id">
            {{ permission.name }}
            <button @click="removePermission(role.id, permission.id)">Retirer</button>
          </li>
        </ul>
        <select v-model="selectedPermission[role.id]">
          <option v-for="permission in availablePermissions(role)" :key="permission.id" :value="permission.id">
            {{ permission.name }}
          </option>
        </select>
        <button @click="addPermission(role.id)">Ajouter une permission</button>
      </li>
    </ul>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import http from '@/http-common'

export default {
  name: 'RoleManager',
  setup() {
    const roles = ref([])
    const permissions = ref([])
    const newRole = ref({ name: '' })
    const selectedPermission = ref({})

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

    const createRole = async () => {
      try {
        await http.post('/roles', { role: newRole.value })
        newRole.value = { name: '' }
        await fetchRoles()
      } catch (error) {
        console.error('Erreur lors de la création du rôle:', error)
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

    const availablePermissions = (role) => {
      return permissions.value.filter(p => !role.permissions.some(rp => rp.id === p.id))
    }

    onMounted(() => {
      fetchRoles()
      fetchPermissions()
    })

    return {
      roles,
      permissions,
      newRole,
      selectedPermission,
      createRole,
      addPermission,
      removePermission,
      availablePermissions
    }
  }
}
</script>