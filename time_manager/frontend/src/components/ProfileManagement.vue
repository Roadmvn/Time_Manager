<template>
  <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
    <div class="px-4 py-6 sm:px-0">
      <h1 class="text-2xl font-semibold text-gray-900">Gestion du profil</h1>
      <form @submit.prevent="updateProfile" class="mt-5 space-y-6">
        <div>
          <label for="username" class="block text-sm font-medium text-gray-700">Nom d'utilisateur</label>
          <input type="text" name="username" id="username" v-model="profile.username"
                 class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
        </div>

        <div>
          <label for="email" class="block text-sm font-medium text-gray-700">Adresse e-mail</label>
          <input type="email" name="email" id="email" v-model="profile.email"
                 class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
        </div>

        <div>
          <label for="new-password" class="block text-sm font-medium text-gray-700">Nouveau mot de passe (laisser vide si inchangé)</label>
          <input type="password" name="new-password" id="new-password" v-model="newPassword"
                 class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
        </div>

        <div>
          <button type="submit"
                  :disabled="isLoading"
                  class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            {{ isLoading ? 'Mise à jour...' : 'Mettre à jour le profil' }}
          </button>
        </div>

        <div v-if="message" :class="['mt-2 text-center text-sm', message.type === 'error' ? 'text-red-600' : 'text-green-600']">
          {{ message.text }}
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '@/store/auth'

const authStore = useAuthStore()

const profile = ref({
  username: '',
  email: ''
})
const newPassword = ref('')
const isLoading = ref(false)
const message = ref(null)

onMounted(async () => {
  try {
    const userProfile = await authStore.fetchUserProfile()
    profile.value = {
      username: userProfile.username,
      email: userProfile.email
    }
  } catch (error) {
    message.value = { type: 'error', text: 'Erreur lors du chargement du profil' }
  }
})

const updateProfile = async () => {
  isLoading.value = true
  message.value = null

  try {
    await authStore.updateProfile({
      ...profile.value,
      ...(newPassword.value ? { password: newPassword.value } : {})
    })
    message.value = { type: 'success', text: 'Profil mis à jour avec succès' }
    newPassword.value = ''
  } catch (error) {
    message.value = { type: 'error', text: 'Erreur lors de la mise à jour du profil' }
  } finally {
    isLoading.value = false
  }
}
</script>