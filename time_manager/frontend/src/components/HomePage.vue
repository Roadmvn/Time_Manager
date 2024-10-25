<template>
  <div class="min-h-[calc(100vh-4rem)] bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
    <div class="container mx-auto px-4 py-12">
      <!-- Section d'accueil -->
      <div class="max-w-4xl mx-auto space-y-8">
        <!-- Carte de bienvenue -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-8 transform hover:scale-[1.02] transition-all duration-300">
          <div class="flex items-center space-x-6">
            <div class="bg-gradient-to-r from-blue-500 to-purple-500 p-4 rounded-full">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div>
              <h1 class="text-3xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Bienvenue, {{ user.username }} !
              </h1>
              <p class="mt-2 text-gray-600 dark:text-gray-400">
                Heureux de vous revoir sur votre TimeManager
              </p>
            </div>
          </div>
        </div>

        <!-- Cartes d'accès rapide -->
        <div class="grid md:grid-cols-2 gap-6">
          <!-- Carte Temps de travail -->
          <router-link to="/app/working-times" 
            class="group bg-white dark:bg-gray-800 rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300">
            <div class="flex items-center space-x-4">
              <div class="bg-blue-100 dark:bg-blue-900 p-3 rounded-lg group-hover:scale-110 transition-transform">
                <span class="text-2xl">⏰</span>
              </div>
              <div>
                <h3 class="text-xl font-semibold text-gray-800 dark:text-white">Temps de travail</h3>
                <p class="text-gray-600 dark:text-gray-400">Gérez vos heures et votre planning</p>
              </div>
            </div>
          </router-link>

          <router-link to="/app/charts" 
            class="group bg-white dark:bg-gray-800 rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300">
            <div class="flex items-center space-x-4">
              <div class="bg-purple-100 dark:bg-purple-900 p-3 rounded-lg group-hover:scale-110 transition-transform">
                <span class="text-2xl">📊</span>
              </div>
              <div>
                <h3 class="text-xl font-semibold text-gray-800 dark:text-white">Statistiques</h3>
                <p class="text-gray-600 dark:text-gray-400">Visualisez vos données</p>
              </div>
            </div>
          </router-link>

          <template v-if="user.role === 'admin' || user.role === 'manager'">
            
            <router-link to="/app/teams" 
              class="group bg-white dark:bg-gray-800 rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300">
              <div class="flex items-center space-x-4">
                <div class="bg-green-100 dark:bg-green-900 p-3 rounded-lg group-hover:scale-110 transition-transform">
                  <span class="text-2xl">🤝</span>
                </div>
                <div>
                  <h3 class="text-xl font-semibold text-gray-800 dark:text-white">Équipes</h3>
                  <p class="text-gray-600 dark:text-gray-400">Gérez vos équipes</p>
                </div>
              </div>
            </router-link>

            <router-link to="/app/users" 
              class="group bg-white dark:bg-gray-800 rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300">
              <div class="flex items-center space-x-4">
                <div class="bg-orange-100 dark:bg-orange-900 p-3 rounded-lg group-hover:scale-110 transition-transform">
                  <span class="text-2xl">👥</span>
                </div>
                <div>
                  <h3 class="text-xl font-semibold text-gray-800 dark:text-white">Utilisateurs</h3>
                  <p class="text-gray-600 dark:text-gray-400">Gérez les membres</p>
                </div>
              </div>
            </router-link>
          </template>
        </div>

        <div class="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-lg">
          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-4">
              <div class="bg-yellow-100 dark:bg-yellow-900 p-3 rounded-lg">
                <span class="text-2xl">💡</span>
              </div>
              <div>
                <h3 class="text-xl font-semibold text-gray-800 dark:text-white">Besoin d'aide ?</h3>
                <p class="text-gray-600 dark:text-gray-400">Consultez notre guide d'utilisation</p>
              </div>
            </div>
            <router-link to="/app/tutorial" 
              class="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg transition-colors">
              Voir le tutoriel
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue';
import { useAuthStore } from '@/store/auth';

export default {
  name: 'HomePage',
  setup() {
    const authStore = useAuthStore();
    const user = computed(() => authStore.user);

    return {
      user
    };
  }
};
</script>