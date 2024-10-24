<template>
  <div id="app" class="min-h-screen bg-gradient-to-b from-blue-50 to-white dark:from-gray-900 dark:to-gray-800 text-gray-800 dark:text-gray-200 flex flex-col justify-between">
    <div class="container mx-auto px-4 py-8 flex flex-col items-center">
      <header class="mb-8 w-full" v-if="isAuthenticated">
        <nav class="relative w-full">
          <div class="flex justify-center items-center space-x-4">
            <router-link to="/" class="text-3xl font-extrabold text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition duration-300">
              TimeManager
            </router-link>
            <button
              @click="toggleMenu"
              class="md:hidden bg-blue-500 text-white p-2 rounded-md hover:bg-blue-600 transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
              :aria-label="isMenuOpen ? 'Fermer le menu' : 'Ouvrir le menu'"
            >
              <span v-if="!isMenuOpen">&#9776;</span>
              <span v-else>&times;</span>
            </button>
          </div>
          <transition
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="transform scale-95 opacity-0"
            enter-to-class="transform scale-100 opacity-100"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="transform scale-100 opacity-100"
            leave-to-class="transform scale-95 opacity-0"
          >
            <ul
              v-show="isMenuOpen || !isMobile"
              class="md:flex md:space-x-6 mt-4 md:mt-0 justify-center bg-white dark:bg-gray-800 shadow-md md:shadow-none rounded-md p-4 md:p-0 md:bg-transparent dark:md:bg-transparent"
            >
              <li v-for="item in navItems" :key="item.path" class="mb-2 md:mb-0">
                <router-link
                  :to="item.path"
                  class="block text-xl text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition duration-300 px-4 py-2 rounded-md hover:bg-blue-100 dark:hover:bg-blue-900"
                  :aria-label="item.ariaLabel"
                  @click="closeMenu"
                >
                  {{ item.name }}
                </router-link>
              </li>
            </ul>
          </transition>
        </nav>
      </header>

      <main class="flex-grow w-full max-w-3xl">
        <transition
          enter-active-class="transition-opacity duration-300"
          enter-from-class="opacity-0"
          enter-to-class="opacity-100"
          leave-active-class="transition-opacity duration-300"
          leave-from-class="opacity-100"
          leave-to-class="opacity-0"
        >
		<router-view v-slot="{ Component }">
			<component :is="Component" />
		</router-view>
        </transition>
      </main>
    </div>

    <footer class="bg-gray-200 dark:bg-gray-900 text-gray-700 dark:text-gray-400 py-4 mt-8 w-full" v-if="isAuthenticated">
  <div class="container mx-auto px-4 flex justify-between ">
    <div>
      <p>Si vous avez un problème, contactez un admin au <strong>+33 6 12 34 56 78</strong></p>
    </div>
    <div>
      <h4 class="font-bold">Comment utiliser le site ? :
        <router-link to="/tutorial" class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 underline">
          Tutoriel
        </router-link>
      </h4>
    </div>
  </div>
</footer>

  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, computed } from 'vue'
// onBeforeMount
import { useAuthStore } from '@/store/auth'

export default {
  name: 'App',
  setup() {
    const isMenuOpen = ref(false)
    const isMobile = ref(window.innerWidth < 768)
    const authStore = useAuthStore()

    const isAuthenticated = computed(() => authStore.isAuth)
    const isAdmin = computed(() => authStore.userRole === 'admin')
    const isManagerOrAdmin = computed(() => ['manager', 'admin'].includes(authStore.userRole))

    const navItems = [
      { name: 'Utilisateurs', path: '/app/users', ariaLabel: 'Aller à la page des utilisateurs' },
      { name: 'Équipes', path: '/app/teams', ariaLabel: 'Aller à la page des équipes' },
      { name: 'Heures de travail', path: '/app/working-times', ariaLabel: 'Aller à la page des heures de travail' },
      { name: 'Graphiques', path: '/app/charts', ariaLabel: 'Aller à la page des graphiques' },
      { name: 'Rôles et permissions', path: '/app/roles', ariaLabel: 'Aller à la page des rôles et permissions' },
      { name: 'Tutoriel', path: '/app/tutorial', ariaLabel: 'Aller à la page du tutoriel' },
    ]

    const toggleMenu = () => {
      isMenuOpen.value = !isMenuOpen.value
    }

    const closeMenu = () => {
      if (isMobile.value) {
        isMenuOpen.value = false
      }
    }

    const handleResize = () => {
      isMobile.value = window.innerWidth < 768
      if (!isMobile.value) {
        isMenuOpen.value = false
      }
    }

    const logout = async () => {
      try {
        await authStore.logout()
        // Rediriger vers la page de connexion après la déconnexion
        this.$router.push('/login')
      } catch (error) {
        console.error('Logout failed:', error)
      }
    }

    onMounted(() => {
      window.addEventListener('resize', handleResize)
    })

    onUnmounted(() => {
      window.removeEventListener('resize', handleResize)
    })

	// onBeforeMount(() => {
	// 	this.authStore.getCurrentUser();
	// })

    return {
      isMenuOpen,
      isMobile,
      navItems,
      toggleMenu,
      closeMenu,
      isAuthenticated,
      isAdmin,
      isManagerOrAdmin,
      logout
    }
  }
}
</script>

<style>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

@media (max-width: 640px) {
  .container {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}

@media (max-width: 480px) {
  body {
    font-size: 14px;
  }
}

button, input, select, textarea {
  min-height: 44px;
  min-width: 44px;
}
</style>
