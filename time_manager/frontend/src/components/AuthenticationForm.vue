<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          {{ isLogin ? 'Connexion' : 'Inscription' }}
        </h2>
      </div>
      <div class="mt-8 space-y-6">
        <LoginForm v-if="isLogin" @switch-mode="toggleMode" />
        <Registration v-else @switch-mode="toggleMode" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import LoginForm from './LoginForm.vue'
import Registration from './UserRegistration.vue'

const isLogin = ref(true)

const toggleMode = () => {
  isLogin.value = !isLogin.value
}
</script>