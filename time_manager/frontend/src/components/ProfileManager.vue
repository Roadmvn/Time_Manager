<template>
  <div class="bg-white dark:bg-gray-800 shadow-lg rounded-lg p-8 max-w-4xl mx-auto">
    <div class="relative mb-8">
      <div class="absolute inset-0 rounded-lg -m-2"></div>
      <h2 class="relative text-3xl font-bold text-gray-800 dark:text-white">
        Mon Profil
        <span class="block mt-2 text-sm font-normal text-gray-500 dark:text-gray-400">
          Gérez vos informations personnelles
        </span>
      </h2>
    </div>

  <!-- Profile Information Card -->
<div class="mb-8 bg-gray-50 dark:bg-gray-700 p-6 rounded-lg border border-gray-100 dark:border-gray-600">
  <div class="flex flex-wrap items-center justify-between space-y-4 md:space-y-0 md:space-x-4">
    <!-- User Info -->
    <div class="flex items-center space-x-4 flex-1 min-w-[200px]">
      <div class="bg-blue-100 dark:bg-blue-900 p-3 rounded-full">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500 dark:text-blue-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
        </svg>
      </div>
      <div>
        <h3 class="text-lg font-semibold text-gray-800 dark:text-white">
          Bienvenue, {{ user.username }} !
        </h3>
        <p class="text-gray-500 dark:text-gray-400">
          {{ user.email }}
        </p>
        <p class="text-gray-500 dark:text-gray-400">
          {{ user.role }}
        </p>
      </div>
    </div>

    <!-- Logout Button -->
    <button
      @click="logout()"
      class="w-full md:w-auto bg-red-500 hover:bg-red-600 text-white px-6 py-2.5 rounded-lg transition duration-200 ease-in-out transform hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 shadow-sm hover:shadow-md flex items-center justify-center space-x-2"
    >
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
      </svg>
      <span>Logout</span>
    </button>
  </div>
</div>


    <!-- Edit Profile Form -->
    <form @submit.prevent="updateProfile" class="space-y-6 bg-gray-50 dark:bg-gray-800/50 p-6 rounded-lg">
      <div class="space-y-6">
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
            Nom d'utilisateur
          </label>
          <input
            v-model="profile.username"
            type="text"
            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white transition-colors duration-200"
            required
          />
        </div>

        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
            Email
          </label>
          <input
            v-model="profile.email"
            type="email"
            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white transition-colors duration-200"
            required
          />
        </div>
      </div>

      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2.5 rounded-lg transition duration-200 ease-in-out transform hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 shadow-sm hover:shadow-md flex items-center space-x-2"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <span>Enregistrer les modifications</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import { ref, computed } from 'vue';
import { useAuthStore } from '@/store/auth';
import { http } from '@/api/network/axios';
import { useRouter } from 'vue-router';

export default {
  name: 'ProfileManager',
  setup() {
    const authStore = useAuthStore();
    const user = computed(() => authStore.user);
    const router = useRouter();

    const profile = ref({
      username: user.value.username,
      email: user.value.email
    });

    async function updateProfile() {
      try {
        console.log('Mise à jour du profil en cours...');
        const response = await http.put(`/users/${user.value.id}`, {
          user: {
            username: profile.value.username,
            email: profile.value.email
          }
        });

        // Mise à jour des données utilisateur dans le store
        if (response.data && response.data.user) {
          authStore.user = {
            ...authStore.user,
            username: response.data.user.username,
            email: response.data.user.email
          };
          console.log('Profil mis à jour avec succès!');
        } else {
          throw new Error("La réponse de l'API ne contient pas les informations utilisateur attendues.");
        }
      } catch (error) {
        console.error('Erreur lors de la mise à jour du profil:', error);
        alert('Erreur lors de la mise à jour du profil. Veuillez réessayer.');
      }
    }

    const logout = async () => {
        const response = await http.post("/logout");
        if (response.status === 200) {
            router.push("/auth");
        }
    }

    return {
      user,
      profile,
      updateProfile,
      logout
    };
  }
};
</script>
