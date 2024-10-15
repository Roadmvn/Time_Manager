<template>
  <div id="app" class="min-h-screen bg-gradient-to-b from-blue-50 to-white dark:from-gray-900 dark:to-gray-800 text-gray-800 dark:text-gray-200">
    <div class="container mx-auto px-4 py-8">
      <header class="mb-8">
        <nav class="relative">
          <div class="flex justify-between items-center">
            <router-link to="/" class="text-2xl font-bold text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition duration-300">
              TimeManager
            </router-link>
            <button
              @click="toggleMenu"
              class="md:hidden bg-blue-500 text-white p-2 rounded-md hover:bg-blue-600 transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
              :aria-label="isMenuOpen ? 'Fermer le menu' : 'Ouvrir le menu'"
            >
              <span v-if="!isMenuOpen">&#9776;</span> <!-- Icône de menu "hamburger" -->
              <span v-else>&times;</span> <!-- Icône "X" pour fermer -->
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
              class="md:flex md:space-x-6 md:justify-center absolute md:relative left-0 right-0 mt-2 md:mt-0 bg-white dark:bg-gray-800 shadow-md md:shadow-none rounded-md md:rounded-none p-4 md:p-0"
            >
              <li v-for="item in navItems" :key="item.path" class="mb-2 md:mb-0">
                <router-link
                  :to="item.path"
                  class="block text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 transition duration-300 px-3 py-2 rounded-md hover:bg-blue-100 dark:hover:bg-blue-900"
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

      <main>
        <transition
          enter-active-class="transition-opacity duration-300"
          enter-from-class="opacity-0"
          enter-to-class="opacity-100"
          leave-active-class="transition-opacity duration-300"
          leave-from-class="opacity-100"
          leave-to-class="opacity-0"
        >
          <router-view></router-view>
        </transition>
      </main>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue'
// Supprimez cette ligne
// import { MenuIcon, XIcon } from 'lucide-vue-next'

export default {
  name: 'App',
  // Supprimez ou commentez ces lignes
  // components: {
  //   MenuIcon,
  //   XIcon
  // },
  setup() {
    const isMenuOpen = ref(false)
    const isMobile = ref(window.innerWidth < 768)

    const navItems = [
      { name: 'Utilisateurs', path: '/users', ariaLabel: 'Aller à la page des utilisateurs' },
      { name: 'Heures de travail', path: '/working-times', ariaLabel: 'Aller à la page des heures de travail' },
      { name: 'Graphiques', path: '/charts', ariaLabel: 'Aller à la page des graphiques' },
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
      navItems,
      toggleMenu,
      closeMenu
    }
  }
}
</script>

<style>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

/* Additional global styles can be added here if necessary */
</style>
