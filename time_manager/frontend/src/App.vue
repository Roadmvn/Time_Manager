<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900 text-gray-800 dark:text-gray-200 flex flex-col justify-between">
    <div class="container mx-auto px-4 py-8 flex flex-col items-center">
      <!-- Header avec navigation -->
      <header class="fixed top-0 left-0 right-0 backdrop-blur-md bg-white/80 dark:bg-gray-900/80 border-b border-gray-200 dark:border-gray-800 z-50 w-full" v-if="isAuthenticated">
        <nav class="container mx-auto px-4">
          <div class="flex items-center justify-between h-16">

            <router-link to="/" class="flex items-center space-x-2">
              <div class="w-8 h-8 bg-gradient-to-r from-blue-500 to-purple-500 rounded-lg flex items-center justify-center">
                <span class="text-white font-bold">T</span>
              </div>
              <span class="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                TimeManager
              </span>
            </router-link>

            <button
              @click="toggleMenu"
              class="md:hidden bg-white/10 p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
              :aria-label="isMenuOpen ? 'Fermer le menu' : 'Ouvrir le menu'"
            >
              <span v-if="!isMenuOpen" class="text-xl">&#9776;</span>
              <span v-else class="text-xl">&times;</span>
            </button>

            <!-- Navigation desktop -->
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
                class="md:flex md:items-center md:space-x-1 absolute md:static left-0 right-0 top-16 md:top-0 bg-white dark:bg-gray-900 md:bg-transparent shadow-md md:shadow-none rounded-b-lg md:rounded-none"
              >
              <template v-if="role === 'user'">
                    <li  v-for="item in navItemsUsers" :key="item.path">
                        <router-link
                            :to="item.path"
                            class="flex items-center space-x-2 px-4 py-3 md:py-2 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-all duration-200"
                            :aria-label="item.ariaLabel"
                            @click="closeMenu"
                        >
                            <span class="text-lg">{{ item.icon }}</span>
                            <span>{{ item.name }}</span>
                        </router-link>
                    </li>
                </template>
                <template v-else-if="role === 'manager'">
                    <li  v-for="item in navItemsManager" :key="item.path">
                        <router-link
                            :to="item.path"
                            class="flex items-center space-x-2 px-4 py-3 md:py-2 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-all duration-200"
                            :aria-label="item.ariaLabel"
                            @click="closeMenu"
                        >
                            <span class="text-lg">{{ item.icon }}</span>
                            <span>{{ item.name }}</span>
                        </router-link>
                    </li>
                </template>
                <template v-else>
                    <li  v-for="item in navItemsAdmin" :key="item.path">
                        <router-link
                            :to="item.path"
                            class="flex items-center space-x-2 px-4 py-3 md:py-2 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-all duration-200"
                            :aria-label="item.ariaLabel"
                            @click="closeMenu"
                        >
                            <span class="text-lg">{{ item.icon }}</span>
                            <span>{{ item.name }}</span>
                        </router-link>
                    </li>
                </template>
              </ul>
            </transition>
          </div>
        </nav>
      </header>

      <!-- Contenu principal -->
      <main class="flex-grow w-full max-w-4xl mt-16">
        <transition
          enter-active-class="transition-all duration-300 ease-out"
          enter-from-class="opacity-0 transform translate-y-4"
          enter-to-class="opacity-100 transform translate-y-0"
          leave-active-class="transition-all duration-300 ease-in"
          leave-from-class="opacity-100 transform translate-y-0"
          leave-to-class="opacity-0 transform translate-y-4"
        >
          <router-view v-slot="{ Component }">
            <component :is="Component" />
          </router-view>
        </transition>
      </main>
    </div>

    <!-- Footer -->
    <footer
      v-if="isAuthenticated"
      class="bg-white/80 dark:bg-gray-900/80 backdrop-blur-md border-t border-gray-200 dark:border-gray-800 py-4 mt-8 w-full"
    >
      <div class="container mx-auto px-4">
        <div class="flex flex-col md:flex-row justify-between items-center gap-4">
          <div class="flex items-center gap-2 text-gray-600 dark:text-gray-400">
            <span>Si vous avez un problème, contactez un admin au  :</span>
            <a
              href="tel:+33612345678"
              class="font-medium hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
            >
              +33 6 12 34 56 78
            </a>
          </div>
          <div>
            <router-link
              to="/app/tutorial"
              class="flex items-center gap-2 text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition-colors"
            >
              <span>Comment utiliser le site ?</span>
              <span class="text-xs">▼</span>
            </router-link>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, computed } from 'vue'
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
	const user = computed(() => authStore.user);
    const role = computed(() => user.value.role)

    const navItemsAdmin = [
      {
        name: 'Utilisateurs',
        path: '/app/users',
        ariaLabel: 'Aller à la page des utilisateurs',
        icon: '👥',
      },
      {
        name: 'Équipes',
        path: '/app/teams',
        ariaLabel: 'Aller à la page des équipes',
        icon: '🤝'
      },
      {
        name: 'Heures de travail',
        path: '/app/working-times',
        ariaLabel: 'Aller à la page des heures de travail',
        icon: '⏰'
      },
      {
        name: 'Graphiques',
        path: '/app/charts',
        ariaLabel: 'Aller à la page des graphiques',
        icon: '📊'
      },
      {
        name: 'Rôles',
        path: '/app/roles',
        ariaLabel: 'Aller à la page des rôles et permissions',
        icon: '🔑'
      },
      {
        name: 'Tutoriel',
        path: '/app/tutorial',
        ariaLabel: 'Aller à la page du tutoriel',
        icon: '📚'
      }
    ]
    const navItemsManager = [
      {
        name: 'Utilisateurs',
        path: '/app/users',
        ariaLabel: 'Aller à la page des utilisateurs',
        icon: '👥',
      },
      {
        name: 'Équipes',
        path: '/app/teams',
        ariaLabel: 'Aller à la page des équipes',
        icon: '🤝'
      },
      {
        name: 'Heures de travail',
        path: '/app/working-times',
        ariaLabel: 'Aller à la page des heures de travail',
        icon: '⏰'
      },
      {
        name: 'Graphiques',
        path: '/app/charts',
        ariaLabel: 'Aller à la page des graphiques',
        icon: '📊'
      },
      {
        name: 'Tutoriel',
        path: '/app/tutorial',
        ariaLabel: 'Aller à la page du tutoriel',
        icon: '📚'
      }
    ]
    const navItemsUsers = [
      {
        name: 'Heures de travail',
        path: '/app/working-times',
        ariaLabel: 'Aller à la page des heures de travail',
        icon: '⏰'
      },
      {
        name: 'Graphiques',
        path: '/app/charts',
        ariaLabel: 'Aller à la page des graphiques',
        icon: '📊'
      },
      {
        name: 'Tutoriel',
        path: '/app/tutorial',
        ariaLabel: 'Aller à la page du tutoriel',
        icon: '📚'
      }
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

    onMounted(() => {
      window.addEventListener('resize', handleResize)
    })

    onUnmounted(() => {
      window.removeEventListener('resize', handleResize)
    })

    return {
      isMenuOpen,
      isMobile,
      navItemsAdmin,
      navItemsManager,
      navItemsUsers,
      toggleMenu,
      closeMenu,
      isAuthenticated,
      isAdmin,
      isManagerOrAdmin,
      user,
      role
    }
  }
}
</script>

<style>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

:root {
  --header-height: 4rem;
}

.page-enter-active,
.page-leave-active {
  transition: opacity 0.3s ease;
}

.page-enter-from,
.page-leave-to {
  opacity: 0;
}

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