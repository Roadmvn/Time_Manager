<template>
  <form class="mt-8 space-y-6" @submit.prevent="handleRegistration">
    <div class="rounded-md shadow-sm -space-y-px">
      <div>
        <label for="username" class="sr-only">Nom d'utilisateur</label>
        <input id="username" name="username" type="text" autocomplete="username" required
               v-model="username"
               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
               placeholder="Nom d'utilisateur">
      </div>
      <div>
        <label for="email-address" class="sr-only">Adresse e-mail</label>
        <input id="email-address" name="email" type="email" autocomplete="email" required
               v-model="email"
               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
               placeholder="Adresse e-mail">
      </div>
      <div>
        <label for="password" class="sr-only">Mot de passe</label>
        <input id="password" name="password" type="password" autocomplete="new-password" required
               v-model="password"
               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
               placeholder="Mot de passe">
      </div>
    </div>

    <div>
      <button type="submit"
              :disabled="isLoading"
              class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
        <span class="absolute left-0 inset-y-0 flex items-center pl-3">
          <UserAddIcon class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400" aria-hidden="true" />
        </span>
        {{ isLoading ? 'Inscription...' : 'S\'inscrire' }}
      </button>
    </div>

    <div class="text-sm text-center">
      <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500" @click="$emit('switch-mode')">
        Déjà un compte ? Se connecter
      </a>
    </div>

    <div v-if="error" class="mt-2 text-center text-sm text-red-600">
      {{ error }}
    </div>
  </form>
</template>

<script setup>
import { ref } from 'vue'
import { useAuthStore } from '@/store/auth'
import { UserAddIcon } from '@heroicons/vue/solid'

const authStore = useAuthStore()

const username = ref('')
const email = ref('')
const password = ref('')
const error = ref('')
const isLoading = ref(false)

const handleRegistration = async () => {
  isLoading.value = true
  error.value = ''

  try {
    await authStore.register(username.value, email.value, password.value)
    // Redirection après inscription réussie
    // router.push('/dashboard')
  } catch (err) {
    error.value = "Échec de l'inscription. Veuillez réessayer."
  } finally {
    isLoading.value = false
  }
}
</script>