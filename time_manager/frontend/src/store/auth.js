import { defineStore } from 'pinia'
import axios from '@/api/network/axios'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: null,
    user: null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
    userRole: (state) => state.user?.role,
  },
  actions: {
    async login(email, password) {
      try {
        const response = await axios.post('/login', { email, password })
        this.token = response.data.token
        this.user = response.data.user
      } catch (error) {
        console.error('Login failed:', error)
        throw error
      }
    },
    async logout() {
      try {
        await axios.post('/logout')
        this.token = null
        this.user = null
      } catch (error) {
        console.error('Logout failed:', error)
        throw error
      }
    },
  },
})